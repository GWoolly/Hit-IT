/// @function create_tilemap_collision_grid()
/// @description Creates a ds_grid to be used as a lookup for custom tile collisions

/*
function create_tilemap_collision_grid(tile_layer_prefix= "tm", chunk_size= 16) {
    // Enum for tile solid directions

    
	// Get all layers with tile layer prefix here.
	
	// For loop for each tile layer
	// Get tile width and height from tilemap.
	
    // Get room dimensions in cells
    var _room_width_cells = ceil(room_width / TILE_SIZE);
    var _room_height_cells = ceil(room_height / TILE_SIZE);
    
    // Create collision grid
    global.collision_grid = ds_grid_create(_room_width_cells, _room_height_cells);
    ds_grid_clear(global.collision_grid, TILE_SOLID.NONE);  // Initialize all cells to 0 (no collision)
    
    // Get all layer IDs in the room
    var _layers = layer_get_all();
    var _layer_count = array_length(_layers);
    
    // Loop through all layers
    for (var i = 0; i < _layer_count; i++) {
        var _layer_id = _layers[i];
        var _tilemap_id = layer_tilemap_get_id(_layer_id);
        
        // Check if this layer has a tilemap
        if (_tilemap_id != -1) {
            var _tileset_name = tilemap_get_tileset(_tilemap_id);
            var _tileset_name_str = asset_get_name(_tileset_name);
            
            // Process the tilemap in chunks for better performance
            for (var cx = 0; cx < _room_width_cells; cx += chunk_size) {
                for (var cy = 0; cy < _room_height_cells; cy += chunk_size) {
                    // Calculate the actual chunk dimensions (handle edge cases)
                    var _chunk_width = min(chunk_size, _room_width_cells - cx);
                    var _chunk_height = min(chunk_size, _room_height_cells - cy);
                    
                    // Process each cell in the chunk
                    for (var xx = 0; xx < _chunk_width; xx++) {
                        for (var yy = 0; yy < _chunk_height; yy++) {
                            var _cell_x = cx + xx;
                            var _cell_y = cy + yy;
                            
                            // Get the tile at this position
                            var _tile_data = tilemap_get(_tilemap_id, _cell_x, _cell_y);
                            
                            // Skip if empty tile
                            if (_tile_data == 0) continue;
                            
                            // Look up collision data in global struct
                            var _collision_value = TILE_SOLID.ALL;  // Default to all sides solid
                            
                            // Check if custom collision data exists
                            if (variable_global_exists("tile_data") && 
                                variable_struct_exists(global.tile_data, _tileset_name_str)) {
                                
                                // Get the tile index
                                var _tile_index = tile_get_index(_tile_data);
                                
                                // Check if this specific tile has custom collision data
                                if (array_length(global.tile_data[$ _tileset_name_str]) > _tile_index) {
                                    _collision_value = global.tile_data[$ _tileset_name_str][_tile_index];
                                }
                            }
                            
                            // Set the collision value in our grid
                            // Use bitwise OR to combine with any existing values (in case of overlapping tilemaps)
                            var _current_value = global.collision_grid[# _cell_x, _cell_y];
                            global.collision_grid[# _cell_x, _cell_y] = _current_value | _collision_value;
                        }
                    }
                }
            }
        }
    }
    
    show_debug_message("Tilemap collision grid initialized: " + string(_room_width_cells) + "x" + string(_room_height_cells));
    return global.collision_grid;
}
*/
// Create the collision grid when the room starts
// Place this code in a room_start event or in a room creation code object
function tile_collision_generate() {
    
	static tile_collision= {};
	
	
	// Initialize the tile_data struct if it doesn't exist
    if (!variable_global_exists("tile_data")) {
        global.tile_data = {};
        
        // Example setup for a sand tileset
        // You would typically set this up somewhere else in your game initialization
        global.tile_data[$ "tsSand"] = array_create(0);
        // First few tiles have default collision (15 = all sides solid)
        for (var i = 0; i < 100; i++) { // Adjust based on your tileset size
            global.tile_data[$ "tsSand"][i] = TILE_SOLID.ALL;
        }
        
        // Example: Override specific tiles with custom collision
        // For example, make tile index 5 only solid on top
        global.tile_data[$ "tsSand"][5] = TILE_SOLID.TOP;
        
        // Example: Make tile index 6 solid on left and right only
        global.tile_data[$ "tsSand"][6] = TILE_SOLID.LEFT | TILE_SOLID.RIGHT;
    }
    
    // Iterate through all tilemap layers
	var _layers= layer_get_all();
	for(var i= 0, iEnd= array_length(_layers);		i<iEnd;	i++){
		
		var _name= layer_get_name(_layers[i]);
		if( string_pos(_name, TILE_LAYER_PREFIX) > 0){// Is tilemap layer
			
			var _roomName= room_get_name(room);
			var _roomInfo= room_get_info(room);
			
			// Generate the 
		}
	}
	
    create_tilemap_collision_grid();
}