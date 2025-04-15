exit

/// Function to generate color-coded collision layers from a source tilemap using chunk optimization
/// @param {layer_id} source_layer - The source tile layer to analyze
/// @param {asset} collision_tileset - The tileset to use for collision tiles
/// @param {int} chunk_size - Size of chunks to check (in tiles)
function generate_collision_layers_chunked(source_layer, collision_tileset, chunk_size) {
	// Get source tilemap
	var tilemap_source = layer_tilemap_get_id(source_layer);
	if (tilemap_source == -1) {
		show_debug_message("ERROR: Source tilemap not found");
		return;
	}
	
	// Get tilemap dimensions
	var width = tilemap_get_width(tilemap_source);
	var height = tilemap_get_height(tilemap_source);
	var tile_width = tilemap_get_tile_width(tilemap_source);
	var tile_height = tilemap_get_tile_height(tilemap_source);
	
	// Define collision types with their corresponding tile indices in the collision tileset
	var collision_types = [
		{
			name: "SOLID",
			flag: 0b1, // Binary enum value 1
			tile_index: 1, // Red tile in collision tileset
			description: "Solid collision"
		},
		{
			name: "PLATFORM",
			flag: 0b10, // Binary enum value 2
			tile_index: 2, // Green tile in collision tileset
			description: "One-way platform"
		},
		{
			name: "SPECIAL",
			flag: 0b100, // Binary enum value 4
			tile_index: 3, // Blue tile in collision tileset
			description: "Special collision"
		}
		// Add more collision types as needed
	];
	
	// Table to track the collision layers we need to create
	var collision_layers = ds_map_create();
	var source_depth = layer_get_depth(source_layer);
	
	// Create a dummy object to use for collision checking (if it doesn't exist)
	if (!object_exists(obj_collision_checker)) {
		show_debug_message("Creating temporary collision checking object");
		var temp_obj = object_add();
		object_set_name(temp_obj, "obj_collision_checker");
		// Minimal collision mask
		object_set_sprite(temp_obj, spr_pixel);
		object_set_mask(temp_obj, spr_pixel);
		object_set_visible(temp_obj, false);
		object_set_persistent(temp_obj, false);
		object_set_solid(temp_obj, false);
	}
	
	// First pass: detect what collision types we have in the level
	// Use chunks to optimize this process
	for (var cx = 0; cx < width; cx += chunk_size) {
		for (var cy = 0; cy < height; cy += chunk_size) {
			// Determine chunk bounds
			var chunk_width = min(chunk_size, width - cx);
			var chunk_height = min(chunk_size, height - cy);
			
			// Convert tilemap coordinates to room coordinates for collision check
			var room_x1 = cx * tile_width;
			var room_y1 = cy * tile_height;
			var room_x2 = room_x1 + (chunk_width * tile_width);
			var room_y2 = room_y1 + (chunk_height * tile_height);
			
			// Create a temporary instance for collision checking
			var checker = instance_create_depth(0, 0, 0, obj_collision_checker);
			
			// Skip empty chunks - check for any tile in the chunk
			var has_tiles = false;
			with (checker) {
				if (collision_rectangle(room_x1, room_y1, room_x2, room_y2, all, false, true) != noone) {
					has_tiles = true;
				}
			}
			
			instance_destroy(checker);
			
			if (!has_tiles) continue;
			
			// Process this chunk
			for (var tx = cx; tx < cx + chunk_width; tx++) {
				for (var ty = cy; ty < cy + chunk_height; ty++) {
					var tile_data = tilemap_get(tilemap_source, tx, ty);
					
					// Skip empty tiles
					if (tile_data == 0) continue;
					
					// Apply mask to get the tile index
					var tile_index = tile_data & tile_index_mask;
					
					// Check for each collision type
					for (var i = 0; i < array_length(collision_types); i++) {
						if (tile_collision_flags[tile_index] & collision_types[i].flag) {
							// Mark this collision type as needed
							ds_map_set(collision_layers, collision_types[i].name, true);
						}
					}
				}
			}
		}
	}
	
	// Second pass: create and populate the necessary collision layers
	var keys = ds_map_keys_to_array(collision_layers);
	var collision_tilemaps = array_create(array_length(keys));
	
	// First create all the layers and tilemaps
	for (var i = 0; i < array_length(keys); i++) {
		var flag_name = keys[i];
		
		// Find the corresponding collision type
		var collision_type_index = -1;
		for (var j = 0; j < array_length(collision_types); j++) {
			if (collision_types[j].name == flag_name) {
				collision_type_index = j;
				break;
			}
		}
		
		if (collision_type_index == -1) continue;
		
		// Create the collision layer
		var layer_name = "tmCollision_" + flag_name;
		var collision_layer = layer_create(source_depth - 1 - i, layer_name);
		
		// Create a binary tilemap on this layer using the collision tileset
		collision_tilemaps[i] = {
			layer_name: layer_name,
			layer_id: collision_layer,
			tilemap_id: layer_tilemap_create(collision_layer, 0, 0, collision_tileset, width, height),
			flag_name: flag_name,
			flag_value: collision_types[collision_type_index].flag,
			tile_index: collision_types[collision_type_index].tile_index
		};
		
		// Make the layer invisible by default
		layer_set_visible(collision_layer, false);
	}
	
	// Now process the tiles in chunks again
	for (var cx = 0; cx < width; cx += chunk_size) {
		for (var cy = 0; cy < height; cy += chunk_size) {
			// Determine chunk bounds
			var chunk_width = min(chunk_size, width - cx);
			var chunk_height = min(chunk_size, height - cy);
			
			// Convert tilemap coordinates to room coordinates for collision check
			var room_x1 = cx * tile_width;
			var room_y1 = cy * tile_height;
			var room_x2 = room_x1 + (chunk_width * tile_width);
			var room_y2 = room_y1 + (chunk_height * tile_height);
			
			// Create a temporary instance for collision checking
			var checker = instance_create_depth(0, 0, 0, obj_collision_checker);
			
			// Skip empty chunks
			var has_tiles = false;
			with (checker) {
				if (collision_rectangle(room_x1, room_y1, room_x2, room_y2, all, false, true) != noone) {
					has_tiles = true;
				}
			}
			
			instance_destroy(checker);
			
			if (!has_tiles) continue;
			
			// Process this chunk for each collision map
			for (var tx = cx; tx < cx + chunk_width; tx++) {
				for (var ty = cy; ty < cy + chunk_height; ty++) {
					var tile_data = tilemap_get(tilemap_source, tx, ty);
					
					// Skip empty tiles
					if (tile_data == 0) continue;
					
					// Apply mask to get the tile index
					var tile_index = tile_data & tile_index_mask;
					
					// Check against each collision map
					for (var i = 0; i < array_length(collision_tilemaps); i++) {
						if (tile_collision_flags[tile_index] & collision_tilemaps[i].flag_value) {
							// Use the corresponding colored tile from collision tileset
							tilemap_set(collision_tilemaps[i].tilemap_id, collision_tilemaps[i].tile_index, tx, ty);
						}
					}
				}
			}
		}
	}
	
	// Clean up
	ds_map_destroy(collision_layers);
}

/// Toggle visibility of collision layers for debugging
/// @param {bool} visible - Whether collision layers should be visible
function toggle_collision_layers_visibility(visible) {
	var all_layers = layer_get_all();
	
	for (var i = 0; i < array_length(all_layers); i++) {
		var layer_name = layer_get_name(all_layers[i]);
		
		// Check if this is a collision layer
		if (string_pos("tmCollision_", layer_name) == 1) {
			layer_set_visible(all_layers[i], visible);
		}
	}
}

// Call this in the room start event or when loading a level
function init_collision_system() {
	// Get the source tile layer
	var source_layer = layer_get_id("tmTiles");
	
	// Use a dedicated tileset for collision (should have at least 4 differently colored tiles)
	// Tile 1: Red (SOLID)
	// Tile 2: Green (PLATFORM/one-way)
	// Tile 3: Blue (SPECIAL)
	var collision_tileset = ts_Collision; // Replace with your collision tileset asset
	
	// Use 10x10 tile chunks for optimization
	var chunk_size = 10;
	
	// Generate all collision layers with chunking optimization
	generate_collision_layers_chunked(source_layer, collision_tileset, chunk_size);
	
	// Hide collision layers by default
	toggle_collision_layers_visibility(false);
	
	// Optionally, show collision layers if debug mode is on
	if (global.debug_mode) {
		toggle_collision_layers_visibility(true);
	}
}

// Example of how to expand COLLISION_FLAG enum

