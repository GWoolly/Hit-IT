/// @desc Function Description
/// @param {array} tileLayersArray	Array of tile layer id's.
/// @param {array} [objectArray]=[] Array containing an object, instance or keywords all/other.
/// @param {function} [callback]	Callback to be run when a collision has been encountered. Function must contain an input struct.
/// @param {real} [maxStep]=8		The tilesize or maximum step size in pixels to prevent going through walls.
/*
 *	Callback Info
 *	=============
 *	Callback's are passed the following struct whenever a collision occurs:
 *
 *	type:	The collision type. COLLISION_FLAG.TILE or COLLISION_FLAG.OBJECT
 *	axis:	String value of the current axis check that the collision occured on.
 *	id:		A tile or instance id.
 *	x:		The x coordinate of the collision.
 *	y:		The y coordinate of the collision.
 *	layer:	The layer id that contains the tileset. This variable is ommited for instances.
 */
function move_to_collision(tileLayersArray, objectArray=[], callback= undefined, maxStep=8){	
	
	
	static dsCollisions= ds_list_create();// A DS list of all instances collided within a collision check
	
    // Collision Pass-thru data & macros
    //==================================
    static data= new collision_data_tile_create(0,0,0, COLLISION.AXIS_Y, 0);// Contains the collision data of a tile or instance.
    
	static collided= false;
	static breakAxis= false;
	
	// Movement handling
	static is_smoothing_corner= false;// If the instance is being smoothly moved around the corner of a collision, it disables the x-axis check.
	static stepX= 0;// Distance moved per step
	static stepY= 0;
	
	 // Apply delta time to velocity
	var _vx= velocity.x * DELTA_RATIO;
	var _vy= velocity.y * DELTA_RATIO;
	
	// Calculate iterations and velocity per step
	var _iterations= (max(abs(_vx), abs(_vy)) div maxStep) + 1;
	stepX= _vx / _iterations;
	stepY= _vy / _iterations;
    //is_smoothing_corner= false;
	
	// Update previous velocity
	velocity_previous.x= velocity.x;
	velocity_previous.y= velocity.y;
	
    
    // 2D platformer
	onGround_previous= onGround;
    onGround= false;
	
	var _data= 10;// Temp delete when finished updating collision handlers

	
	// Iterate through velocity steps
	//===============================
	for(var i= 0;	i < _iterations;	i++){// Move and collide
		
		// End collision checks if not moving
		if( (stepX == 0 && stepY == 0)){ break;}		
		is_smoothing_corner= false;
		
		// Position to check
		var _checkX= ceil(abs(stepX)) * sign(stepX);// Proper rounding into moving direction
		var _checkY= ceil(abs(stepY)) * sign(stepY);
		
		var _breakAxis= false;
		
		//Tiles Y
		//================================
		
		//Clamp bbox to the room's bounds.
		var _bbt= clamp(bbox_top + stepY, 0, room_height-1);
		var _bbb= clamp(bbox_bottom + stepY, 0, room_height-1);
		
		var _bbl= clamp(bbox_left + 0, 0, room_width-1);//Adding 1 to bbox_left as we don't want to accidentally catch the wall.
		var _bbr= clamp(bbox_right - 1, 0, room_width-1);
		
		collided= false;
		
		for(var t= 0, tEnd=array_length(tileLayersArray);	t < tEnd;	t++){
			
            //Get current tilemap info
            var _tilemapID= layer_tilemap_get_id( tileLayersArray[t]);
            var _tileSize= tilemap_get_tile_width( _tilemapID);
			
            var _x1= tilemap_get_cell_x_at_pixel(_tilemapID, _bbl, _bbt);
            var _y1= tilemap_get_cell_y_at_pixel(_tilemapID, _bbl, _bbt); 
            var _x2= tilemap_get_cell_x_at_pixel(_tilemapID, _bbr, _bbb);
            var _y2= tilemap_get_cell_y_at_pixel(_tilemapID, _bbr, _bbb);
                                                                                 
            //Make FOR loop dynamic
            if(velocity.y > 0){ 
                var _yDir= 1;
                var _yStart= _y1;
                var _yEnd= _y2 + 1;
            }
            else{
                var _yDir= -1;
                var _yStart= _y2;
                var _yEnd= _y1 - 1;
            }
            
            //Check each tile cell within bbox
            for(iy= _yStart;    iy != _yEnd;     iy+= _yDir){
                for(var ix=_x1;	ix <= _x2;	ix++){
                    
                    // Check if colliding with tile
                    var _tile= tilemap_get(_tilemapID, ix, iy);
                    if(_tile > 0){
						
                        data= new collision_data_tile_create(_tile, ix * _tileSize, iy * _tileSize, COLLISION.AXIS_Y, tileLayersArray[t]);
						
						callback(data);// Perform collision callback
						
						if(collided == true){// Stop checking this axis if colliding.
							_breakAxis= true;
							stepY= 0;
							break;
						}
						
						if(is_smoothing_corner == true){
							break;
						}
                    }
                }
				if(collided == true || is_smoothing_corner == true){break;}// Stop checking this axis if colliding.
            }
        }
		
        
		//Tiles X
		//================================
		
		if(COLLISION_FLAG_CORNER_SMOOTHING == false){
		//Clamp bbox to the room's bounds.
		_bbt= clamp(bbox_top + 0, 0, room_height-1);
		_bbb= clamp(bbox_bottom - 1, 0, room_height-1);
		
		_bbl= clamp(bbox_left + stepX, 0, room_width-1);
		_bbr= clamp(bbox_right + stepX, 0, room_width-1);
		
		collided= false;
		
		//if( COLLISION_FLAG_CORNER_SMOOTHING){
		for(var t= 0, tEnd=array_length(tileLayersArray);	t < tEnd;	t++){
			
			//Get current tilemap info
			var _tilemapID= layer_tilemap_get_id( tileLayersArray[t]);
			var _tileSize= tilemap_get_tile_width( _tilemapID);
			
            // Get tilemap cells of bbox
            var _x1= tilemap_get_cell_x_at_pixel(_tilemapID, _bbl, _bbt);
            var _y1= tilemap_get_cell_y_at_pixel(_tilemapID, _bbl, _bbt);
            var _x2= tilemap_get_cell_x_at_pixel(_tilemapID, _bbr, _bbb);
            var _y2= tilemap_get_cell_y_at_pixel(_tilemapID, _bbr, _bbb);
            
            //Make FOR loop dynamic
            if(velocity.x > 0){ 
                var _xDir= 1;
                var _xStart= _x1;
                var _xEnd= _x2 + 1;
            }
            else{
                var _xDir= -1;
                var _xStart= _x2;
                var _xEnd= _x1 - 1;
            }
            
            //Check each tile cell within bbox
            for(ix= _xStart;    ix != _xEnd;     ix+= _xDir){
                for(var iy=_y2;	iy >= _y1;	iy--){
                    
                    // Check if colliding with tile
                    var _tile= tilemap_get(_tilemapID, ix, iy);
                    if(_tile > 0){
                        
                        data= new collision_data_tile_create(_tile, ix * _tileSize, iy * _tileSize, COLLISION.AXIS_X, tileLayersArray[t]);
						
						callback(data);// Perform collision callback
						
						
						if(collided == true){// Stop checking this axis if colliding.
							stepX= 0;
							break;
						}
                    }
                }
				if(collided == true){break;}// Stop checking this axis if colliding.
            }
		}
		}
		
		
        // Instances Y
		//=====================================
		collided= false;
		is_smoothing_corner= false;
		ds_list_clear(dsCollisions);
		if( instance_place_list(x, y + _checkY, objectArray, dsCollisions, true) > 0){
			
			data= new collision_data_instance_create(dsCollisions[| 0], x, y + _checkY, COLLISION.AXIS_Y);
			_data= noone;
			
			// Check callback for collision
			//=============================
			for(var l=0, L=ds_list_size(dsCollisions);	l < L;	l++){
				
				data.id= dsCollisions[| l];	// Set current collider data
				
				callback(data);// Perform collision callback
				if(collided == true){// Stop checking this axis if colliding.
					stepY= 0;
					break;
				}
            }
		}
		
		
		// Instances X
		//=====================================
		collided= false;
		ds_list_clear(dsCollisions);
		if( instance_place_list(x + _checkX, y, objectArray, dsCollisions, true) > 0 && is_smoothing_corner= false){
			
			data= new collision_data_instance_create(dsCollisions[| 0], x + _checkX, y, COLLISION.AXIS_X);
			_data= noone;
			
			// Check callback for collision
			//=============================
			for(var l=0, L=ds_list_size(dsCollisions);	l < L;	l++){
				
				data.id= dsCollisions[| l];			// Get current collider
				
				callback(data);// Perform collision callback
				
				if(collided == true){// Stop checking this axis if colliding.
					stepX= 0;
					break;
				}
			}
		}
		
		// Update position
		x= x + (stepX);
		y= y + (stepY);
	}
}