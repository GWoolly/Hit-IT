/// @desc Generates the tile collision data for the currently active room.
///         This function should be placed within the room start event of an instance.
function room_tile_collision_generate(){
	
	global.tile_data.tilemap= {};// Create out all room data
	
    var _roomInfo= room_get_info(room, false, false, true, true, true)// Only get the layer and tilemap_data
    
	var _layers= _roomInfo.layers;
	for( var l= 0, lEnd= array_length(_layers); l < lEnd;	l++){// Iterate through layers array
		
		for( var e= 0, eEnd= array_length( _layers[l].elements);	e < eEnd;	e++){// Iterate through elements array
			
			var _layerID= _layers[l].id;
			var _content= _layers[l].elements[e];
			
			if( variable_struct_exists(_content, "tileset_index") == true){// Is tile layer
				
				if(variable_struct_exists(global.tile_data.tileset, string(_content.tileset_index)) == false){// Tilemap not defined
					show_debug_message($"Could not generate tilemap for tileset {_content.tileset_index}: {tileset_get_name(_content.tileset_index)} in {room_get_name(room)}");
				}
				else {// Generate the proxy tilemap
					
					// Get tilemap
					var _tileset= global.tile_data.tileset[$ _content.tileset_index].flags
					var _tilemapID= _content.id;
				
					// Create a proxy tilemap
					var _mapW= tilemap_get_width(_tilemapID);
					var _mapH= tilemap_get_height(_tilemapID);
                    
                    // Create 2D array
                    global.tile_data.tilemap[$ _tilemapID]= [];
                    for(var a= _mapW;   a >= 0; a--){
                        global.tile_data.tilemap[$ _tilemapID][a]= array_create(_mapH, 0);
                        global.tile_data.tilemap[$ _tilemapID][a][_mapH]= 0;
                    }
				    
                    // Iterate through all tiles on the tilemap
                    //=========================================
					for( var t= array_length(_content.tiles)-1;	t >= 0;	t--){
                        
						var _tileRaw= _content.tiles[t];// Tile index with rotation, mirror and flip bitmask.
						var _index= _tileRaw & tile_index_mask;
					
						if(_index == 0){continue;}// Skip if no tile present
					
						// Get tile's transform bitmask
						var _flags= real(_tileset[_index]);
						var _bits= _flags & TILE_FLAG.ALL;// Just the collision flags
					   
						if(_tileRaw & tile_rotate){// Rotate flags
							_bits= (((_bits & 1) << 3) + (_bits >> 3)) & TILE_FLAG.ALL;
						}
					
						if(_tileRaw & tile_mirror){// Mirror flags
							var _x= ((_bits & TILE_FLAG.LEFT) << 2 ) + ((_bits & TILE_FLAG.RIGHT) >> 2 );
							_bits= (_bits & ~(TILE_FLAG.LEFT + TILE_FLAG.RIGHT)) + _x;
						}
					
						if(_tileRaw & tile_flip){// Flip flags
							var _y= ((_bits & TILE_FLAG.TOP) << 2 ) + ((_bits & TILE_FLAG.DOWN) >> 2 );
							_bits= (_bits & ~(TILE_FLAG.TOP + TILE_FLAG.DOWN)) + _y;
						}
					
                        var _testExt= (_flags & ~TILE_FLAG.ALL);
                        var _test= _testExt + _bits
                        var _test= _testExt | _bits;
						global.tile_data.tilemap[$ _tilemapID][t mod _mapW][t div _mapW]= real((_flags & ~TILE_FLAG.ALL) + _bits);// Add transformed bits back on to the remaining bits when using an extended bitmask for tiles.
					}
				
					show_debug_message($"Finished generating tilemap {_tilemapID}, {_mapW}x{_mapH} on layer {_layerID}: {_layers[l].name} in {room_get_name(room)}");
				}
			}
			
		}
	}
}



/**
 * Creates a new dataset for tile collisions using the specified tileset. Note that you will need to use the bake function to finalise the tileset for use.
 * @param {asset.GMTileSet, string} tileset Tileset asset
 * @returns {id.DsGrid} Pointer to the tileset's DS grid for editing flags.
 */
function tile_collision_data_create(tileset){
    var _tilesetName= "";
    
	// Get tileset name for serialisation
	if(is_string(tileset) == false){
		_tilesetName= tileset_get_name(tileset);
	}
	else{
		_tilesetName= tileset;
	}
	
	// Get current index of tileset
	var _tilesetID= asset_get_index(_tilesetName);
	
	// Get tilset info
    var _tileInfo= tileset_get_info(_tilesetID);
    var _width= _tileInfo.tile_columns;
    var _height= _tileInfo.tile_count / _width;
    
	
	// Ensure global var exists
	if( variable_global_exists("tile_data") == false){
		global.tile_data= {
			"editing": noone,// Current tileset having its tile data edited before baking.
			"tilemap": {},// Empty struct for level's tilemap layer id's.
            "tileset": {},
		};
	}
	
    // Create grid and return it
    var _grid= ds_grid_create(_width, _height);
	
	// Add tileset data to global.tile_data
    global.tile_data.tileset[$ _tilesetID]= {
		asset: _tilesetName,
		flags: _grid
	};
    
	global.tile_data[$ "editing"]= _tilesetID;// Quick reference for the baking of data func.
	
	return _grid;// Return ptr to tileset's data
}



/**
 * Finalises the tileset that is being edited during creation.
 */
function tile_collision_data_bake(){
    
    // Convert ds_grid to lookup array
    if( global.tile_data != noone){
        
		var tile_data= global.tile_data.tileset[$ global.tile_data.editing];// Current tileset being edited from tile_collision_data_create().
		
        var _width= ds_grid_width(tile_data.flags);
        var _height= ds_grid_height(tile_data.flags);
        var _size= _width * _height;
        var _array= array_create(_size, TILE_FLAG.NONE);
        
        // Populate the array
        for(var i= 0;   i < _size; i++){
            var _x= i mod _width;
            var _y= i div _width;
            
            _array[i]= tile_data.flags[# _x, _y];
        }
        
		// Finalise Data
        ds_grid_destroy(tile_data.flags);
        tile_data.flags= _array;
		global.tile_data.editing= noone;
    }
}



/**
*  Returns tile collision data.
* @param {id.tilemapelement} tilemap_id  The id of the tilemap to check for a collision.
* @param {real} x  X pixel coordinate.
* @param {real} y  Y pixel coordinate.
* @returns {real}  Returns the tile collision data of the given coordinates.
*/
function collision_tile_get_pixel(tilemap_id, x, y){
    try{
        // Get bitmask to convert pixel coordinates to cell coordinates.
        //var _tileW= ~(tilemap_get_tile_width(tilemap_id) - 1);
        //var _tileH= ~(tilemap_get_tile_height(tilemap_id) - 1);
        
        //In / Out data
        var _data= global.tile_data.tilemap[$ real(tilemap_id)];
        
        
        // Clamp target to bounds
        x= clamp(x, 0, room_width) div tilemap_get_tile_width(tilemap_id);
        y= clamp(y, 0, room_height) div tilemap_get_tile_height(tilemap_id);
        
        var _test= _data[x][y];
        if(_test > 0){
            var _test= true;
        }
        
        return _data[x][y];
    }
    catch(e){
        if( tilemap_id == undefined || tilemap_id < 0){
            var msg= "Error collision_tile_get_pixel:: Tilemap is undefined!"
            show_debug_message(msg)
            show_error(msg, false);
            return 0;
        }
        show_error(e, false);
    }
}



/**
 *  Returns tile collision data as a bit mask.
 * @param {id.tilemapelement} tilemap_id  The id of the tilemap to check for a collision.
 * @param {real} x1  Left pixel coordinate.
 * @param {real} y1  Top pixel coordinate.
 * @param {real} x2  Right pixel coordinate.
 * @param {real} y2  Bottom pixel coordinate.
 * @returns {real}  Returns the tile collision data of the given rectangle.
 */
function collision_tile_get_rectangle(tilemap_id, x1, y1, x2, y2){
    
    // Get bitmask to convert pixel coordinates to cell coordinates.
    var _tileW= ~(tilemap_get_tile_width(tilemap_id) - 1);
    var _tileH= ~(tilemap_get_tile_height(tilemap_id) - 1);
    
    //In / Out data
    var _data= global.tile_data.tilemap[$ tilemap_id];
    
    
    // Clamp target to bounds
    x1= clamp(x1 & _tileW, 0, array_length(_data));
    x2= clamp(x2 & _tileW, 0, array_length(_data));
    y1= clamp(y1 & _tileH, 0, array_length(_data[0]));
    y2= clamp(y2 & _tileH, 0, array_length(_data[0]));
        
    var _flags= TILE_FLAG.NONE;
    
    for(var _x= x1; _x <= x2;   _x++){
        for(var _y= y1; _y <= y2;   y++){
            
            _flags= _flags | _data[_x][_y];
        }
    }
    
    return _flags;
}



/**
*  Returns tile collision data as an array of bit mask values.
* @param {id.tilemapelement} tilemap_id  The id of the tilemap to check for a collision.
* @param {real} x1  Left pixel coordinate.
* @param {real} y1  Top pixel coordinate.
* @param {real} x2  Right pixel coordinate.
* @param {real} y2  Bottom pixel coordinate.
* @returns {array.real}  Returns an array of tile collision data of the given rectangle.
*/
function collision_tile_get_rectangle_array(tilemap_id, x1, y1, x2, y2){
    
    // Get bitmask to convert pixel coordinates to cell coordinates.
    var _tileW= ~(tilemap_get_tile_width(tilemap_id) - 1);
    var _tileH= ~(tilemap_get_tile_height(tilemap_id) - 1);
    
    //In / Out data
    var _data= global.tile_data.tilemap[$ tilemap_id];
    
    
    // Clamp target to bounds
    x1= clamp(x1 & _tileW, 0, array_length(_data));
    x2= clamp(x2 & _tileW, 0, array_length(_data));
    y1= clamp(y1 & _tileH, 0, array_length(_data[0]));
    y2= clamp(y2 & _tileH, 0, array_length(_data[0]));
 
    var _flags= array_create(abs(x1 - x2) * abs(y1 - y2), TILE_FLAG.NONE);// Populate the array
    var i= 0;
    
    for(var _x= x1; _x <= x2;   _x++){
        for(var _y= y1; _y <= y2;   _y++){
            
            _flags[i]= _data[_x][_y];
            i++;
        }
    }
    
    return _flags;
}



