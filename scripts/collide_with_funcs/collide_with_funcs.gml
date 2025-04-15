///// @desc Snaps the object to a free position in the X axis.
/////
///// @param {real} x_position	The x position to check.
///// @param {real} y_position	The y position to check.
///// @param {any*} collision		An object, instance, tile map ID, keywords all/other, or array containing these items
///// @param {real} distance		Max distance to check for no collision.
///// @param {real} [step]=1		Step size to reach distance.
///// @param {sign} [checkSign]=0		Check for collision in either the positive (1) or negaitve (-1) direction, or both (0).
/////
///// @returns {bool} True if collision is present and object can't move.
//function collide_corner_snap_x(x_position, y_position, collision, distance, step= 1, checkSign= 0){
	//
	//checkSign= sign(checkSign);
	//step= max(1, step);
	//
	//// Check for no collision radiating outwards from given position.
	//for(var i= 1;	i <= distance;		i+= step){
		//
		//// Check direction based on sign
		//for(var s= 1;	s >= -2;	s+= -2){// From Maddy's Celeste on Pico8, check forwards (1) then backwards (-1).
			//
			//// Perform check if we're not ignoring this checkSign
			//if( s != checkSign){
				//
				//// Check for no collision
				//if( place_meeting(x_position + (s * i), y_position, collision) == false){
					//self.x= x_position + (s * i);
					//return false;
				//}
			//}
		//}
	//}
	//return true;
//}
//




function collide_oneway_platform(snap_y){
	var in= move_to_collision.data;
	
	if(in.isInstance == true){
		var _inst= in.id;
		
		// Snap to platform when player is above
		if(in.axis == 1 && velocity.y >= 0
		&& ( min(bbox_bottom, (y - yprevious) - bbox_bottom) /*+ min(0, in.vy)*/ <= _inst.bbox_top + snap_y /*+max(0, _inst.velocity.y)*/) ){
		
			//Snap to platform
			var _offsetY= bbox_bottom - y;
			y= _inst.bbox_top - _offsetY;
			
			//Update instance values
			/*
			velocity.y= (_inst.velocity.y >= 0)?	max(ceil(_inst.velocity.y), 1)	:	1;
			/*/
			velocity.y= _inst.velocity.y +1
			//*/
			onGround= true;
			groundY= y;
			
			return true;
		}
		else{// Pass through floor
			return false;
		}
	}
	else{//in.type == COLLISION_FLAG.TILE
		
		var _tileSize= tilemap_get_tile_height( layer_tilemap_get_id(in.layer));
		var _tileLayer= TILE_LAYER_DATA[$ in.layer];// Data from oTilemapManager
		
		var _yG= (in.y - _tileLayer.y) div _tileSize * _tileSize + _tileLayer.y
		
		
		if(velocity.y >= 0												// Instance is moving down
		&& bbox_bottom + min(0, _tileLayer.velocity.y) <= _yG + snap_y){// Instance bb_bottom is higher than ground + layer.velocity
			y= _yG + (bbox_bottom - y);
			velocity.y= max((_tileLayer.velocity.y), 1);
			
			onGround= true;
			groundY= y;
			//velocity.y= _thisTileLayer.velocity.y + 1 // Player stays stuck in platform even at high speeds!
			return true;
		}
		else{
			return false;
		}
	}
	return false;// No collision
}






/// @desc Moves the calling object to a point where it no longer collides with the given collision.
/// @param {struct} in		Input struct supplied by the move_to_collision script.
///
/// @returns {bool}			False, instructing the move_to_collision script to stop processing additional collisions in the current axis.
function collide_solidOLD(collide_with= true){
	
	//// Ignore collision if corner snapping or collision is disabled
	//if(collide_with == false || COLLISION_FLAG_CORNER_SMOOTHING){
		//COLLISION_FLAG_COLLIDED= false;
		//exit;
	//}
	
	var in= move_to_collision.data;
	
	if(COLLISION_IS_INSTANCE){
		var _inst= COLLISION_GET_ID;
		
		switch(COLLISION_GET_AXIS){
			case COLLISION_AXIS_Y:
				if( bbox_bottom >= _inst.bbox_bottom ){// Is underneath collision
					var _targetY= _inst.bbox_bottom + (y - bbox_top);
					y= _targetY;
					velocity.y= max(0, _inst.velocity.y);
                    COLLISION_FLAG_COLLIDED= true;
					return true;
				}
				else{//Is standing on collision
					
					y= _inst.bbox_top - (bbox_bottom - y);
					velocity.y= min(0, _inst.velocity.y);
					
					groundY= _inst.bbox_top;
					onGround= true;
                    COLLISION_FLAG_COLLIDED= true;
					return true;
				}
			case COLLISION_AXIS_X:
				if( bbox_left >= _inst.bbox_right - 1){// Is to right of collision
					
					x= _inst.bbox_right + (x - bbox_left);
					//x++;
					velocity.x= max(0, _inst.velocity.x);
					return true;
				}
				else{//Is to left of collision
					
					x= _inst.bbox_left - (bbox_right - x) - 0;
					velocity.x= min(0, _inst.velocity.x);
                    COLLISION_FLAG_COLLIDED= true;
					return true;
				}
			default: //Exception
                COLLISION_FLAG_COLLIDED= false;
                return false;
		}
	}
	else{// isTile
		if( COLLISION_GET_AXIS == COLLISION_AXIS_X){
                var _tileSize = tilemap_get_tile_width(layer_tilemap_get_id(in.layer));
                            
                if(velocity.x >= 0){// Hit solid to the right
                    var _layerX = layer_get_x(in.layer);
                    
                    // Reposition - fix to avoid jittering
                    var _offsetX = bbox_right - x;
                    // Calculate the tile's left edge
                    var _tileLeftEdge = (in.x & ~(_tileSize-1)) + _layerX;
                    // Position player to the left of the tile
                    x = _tileLeftEdge - _offsetX - 0;
                    
                    // Change velocity
                    velocity.x = 0;
                    COLLISION_FLAG_COLLIDED= true;
                    return true;
                }
                else{// Hit solid to the left
                    var _layerX = layer_get_x(in.layer);
                    
                    // Reposition - fix to avoid jittering
                    var _offsetX = x - bbox_left;
                    // Calculate the tile's right edge
                    var _tileRightEdge = ((in.x + _offsetX) & ~(_tileSize-1)) + _tileSize + _layerX;
                    // Position player to the right of the tile
                    x = _tileRightEdge;
                    
                    // Change velocity
                    velocity.x = 0;
                    COLLISION_FLAG_COLLIDED= true;
                    return true;
                }
        }
        else{// COLLISION_AXIS_Y
			
                var _tileSize = tilemap_get_tile_height(layer_tilemap_get_id(in.layer));
                var _layerY = layer_get_y(in.layer);
                            
                // Snap to position
                if(velocity.y >= 0){// Collided with floor
                    // Reposition to floor - fix for jittering
                    var _offsetY = bbox_bottom - y;
                    // Calculate the tile's top edge
                    var _tileTopEdge = ((in.y + _offsetY) & ~(_tileSize-1)) + _layerY;
                    // Position player on top of the tile
                    y = _tileTopEdge - _offsetY;
                    
                    // Change velocity
                    velocity.y = TILE_LAYER_DATA[$ in.layer].velocity.y;
                    
                    onGround = true;
                    groundY = y + _offsetY; // Store the ground y position correctly
                    COLLISION_FLAG_COLLIDED= true;
                    return true;
                }
                else{// Collided with ceiling
                    // Reposition to ceiling
                    var _offsetY = y - bbox_top;
                    // Calculate the tile's bottom edge
                    var _tileBottomEdge = ((in.y) & ~(_tileSize-1)) + _tileSize + _layerY;
                    // Position player below the tile
                    y = _tileBottomEdge + _offsetY;
                    
                    // Change velocity
                    velocity.y = TILE_LAYER_DATA[$ in.layer].velocity.y;
                    COLLISION_FLAG_COLLIDED= true;
                    return true;
                }
			
			//default://Exception
                //COLLISION_FLAG_COLLIDED= false;
                //return false;
		}
	}
	
	// Default return
	return true;// Has collided
}







function collide_corner_snap(in, distance, smoothing= 0.75, step_size, check_direction= sign(0)){
	
	//if(in.isInstance == true){//Instance
		//
		//var _offsetX= sign(check_direction) * distance;
		
		if( place_meeting(in.x + distance, in.y - 1, in.id) == false){// Slide to right
			
			x+= min(1, lerp(0, distance, smoothing));
			
			velocity.x= max(0, velocity.x);
			move_to_collision.stepX= max(0, move_to_collision.stepX);
			
			move_to_collision.is_smoothing_corner= true;
			COLLISION_FLAG_COLLIDED= false;
			COLLISION_FLAG_CORNER_SMOOTHING= true;
			return false;
		}
		else if( place_meeting(in.x - distance, in.y - 1, in.id) == false){// Slide to left
			
			x-= min(1, lerp(0, distance, smoothing));
			
			velocity.x= min(0, velocity.x);
			move_to_collision.stepX= min(0, move_to_collision.stepX);
			
			move_to_collision.is_smoothing_corner= true;
			COLLISION_FLAG_COLLIDED= false;
			COLLISION_FLAG_CORNER_SMOOTHING= true;
			return false;
		}
		return true;
	//}
	//else{//Tile
		//show_debug_message("collide_corner_snap: is tile")
	//}
	//return true;
}


//
///// @desc Moves the calling object to a point where it no longer collides with the given collision.
///// @param {real} distance     Distance to check for corner snapping (optional).
///// @param {real} smoothing    Smoothing factor for corner snapping (optional, default 0.75).
/////
///// @returns {bool}            False if no collision found. True will instruct the move_to_collision script to stop processing additional collisions in the current axis.
//function collide_solid(distance = 0, smoothing = 0.75) {
	//
	//var in = move_to_collision.data;
	//
	//var _testA= COLLISION_GET_AXIS;
	//var _testB= COLLISION_AXIS_Y 
	//
	//// Check for corner smoothing if distance is provided
	//if (distance > 0 && COLLISION_GET_AXIS == COLLISION_AXIS_Y && velocity.y < 0) {
		//// Only apply corner smoothing for downward collisions (standing on surfaces)
		//if (COLLISION_IS_INSTANCE) {
			//if (place_meeting(in.x + distance, in.y - 1, COLLISION_GET_ID) == false) { // Slide to right
				//x += min(1, lerp(0, distance, smoothing));
				//
				//velocity.x = max(0, velocity.x);
				//move_to_collision.stepX = max(0, move_to_collision.stepX);
				//
				//move_to_collision.is_smoothing_corner = true;
				//COLLISION_FLAG_COLLIDED = false;
				//COLLISION_FLAG_CORNER_SMOOTHING = true;
				//return false;
			//}
			//else if (place_meeting(in.x - distance, in.y - 1, COLLISION_GET_ID) == false) { // Slide to left
				//x -= min(1, lerp(0, distance, smoothing));
				//
				//velocity.x = min(0, velocity.x);
				//move_to_collision.stepX = min(0, move_to_collision.stepX);
				//
				//move_to_collision.is_smoothing_corner = true;
				//COLLISION_FLAG_COLLIDED = false;
				//COLLISION_FLAG_CORNER_SMOOTHING = true;
				//return false;
			//}
		//} else {
			//// Handle tile-based corner smoothing
			//var _tileSize = tilemap_get_tile_width(layer_tilemap_get_id(in.layer));
			//var _layerX = layer_get_x(in.layer);
			//var _layerY = layer_get_y(in.layer);
			//
			//// Check right corner
			//if (!tilemap_get_at_pixel(layer_tilemap_get_id(in.layer), in.x + distance, in.y - 1)) {
				//x += min(1, lerp(0, distance, smoothing));
				//
				//velocity.x = max(0, velocity.x);
				//move_to_collision.stepX = max(0, move_to_collision.stepX);
				//
				//move_to_collision.is_smoothing_corner = true;
				//COLLISION_FLAG_COLLIDED = false;
				//COLLISION_FLAG_CORNER_SMOOTHING = true;
				//return false;
			//}
			//// Check left corner
			//else if (!tilemap_get_at_pixel(layer_tilemap_get_id(in.layer), in.x - distance, in.y - 1)) {
				//x -= min(1, lerp(0, distance, smoothing));
				//
				//velocity.x = min(0, velocity.x);
				//move_to_collision.stepX = min(0, move_to_collision.stepX);
				//
				//move_to_collision.is_smoothing_corner = true;
				//COLLISION_FLAG_COLLIDED = false;
				//COLLISION_FLAG_CORNER_SMOOTHING = true;
				//return false;
			//}
		//}
	//}
	//
	//// If corner smoothing didn't occur or wasn't attempted, proceed with normal solid collision
	//if (COLLISION_IS_INSTANCE) {
		//var _inst = COLLISION_GET_ID;
		//
		//switch (COLLISION_GET_AXIS) {
			//case COLLISION_AXIS_Y:
				//if (bbox_bottom >= _inst.bbox_bottom) { // Is underneath collision
					//var _targetY = _inst.bbox_bottom + (y - bbox_top);
					//y = _targetY;
					//velocity.y = max(0, _inst.velocity.y);
					//COLLISION_FLAG_COLLIDED = true;
					//return true;
				//}
				//else { // Is standing on collision
					//y = _inst.bbox_top - (bbox_bottom - y);
					//velocity.y = min(0, _inst.velocity.y);
					//
					//groundY = _inst.bbox_top;
					//onGround = true;
					//COLLISION_FLAG_COLLIDED = true;
					//return true;
				//}
			//case COLLISION_AXIS_X:
				//if (bbox_left >= _inst.bbox_right - 1) { // Is to right of collision
					//x = _inst.bbox_right + (x - bbox_left);
					//velocity.x = max(0, _inst.velocity.x);
					//COLLISION_FLAG_COLLIDED = true;
					//return true;
				//}
				//else { // Is to left of collision
					//x = _inst.bbox_left - (bbox_right - x) - 0;
					//velocity.x = min(0, _inst.velocity.x);
					//COLLISION_FLAG_COLLIDED = true;
					//return true;
				//}
			//default: // Exception
				//COLLISION_FLAG_COLLIDED = false;
				//return false;
		//}
	//}
	//else { // isTile
		//if (COLLISION_GET_AXIS == COLLISION_AXIS_X) {
			//var _tileSize = tilemap_get_tile_width(layer_tilemap_get_id(in.layer));
						//
			//if (velocity.x >= 0) { // Hit solid to the right
				//var _layerX = layer_get_x(in.layer);
				//
				//// Reposition - fix to avoid jittering
				//var _offsetX = bbox_right - x;
				//// Calculate the tile's left edge
				//var _tileLeftEdge = (in.x & ~(_tileSize-1)) + _layerX;
				//// Position player to the left of the tile
				//x = _tileLeftEdge - _offsetX - 0;
				//
				//// Change velocity
				//velocity.x = 0;
				//COLLISION_FLAG_COLLIDED = true;
				//return true;
			//}
			//else { // Hit solid to the left
				//var _layerX = layer_get_x(in.layer);
				//
				//// Reposition - fix to avoid jittering
				//var _offsetX = x - bbox_left;
				//// Calculate the tile's right edge
				//var _tileRightEdge = ((in.x + _offsetX) & ~(_tileSize-1)) + _tileSize + _layerX;
				//// Position player to the right of the tile
				//x = _tileRightEdge;
				//
				//// Change velocity
				//velocity.x = 0;
				//COLLISION_FLAG_COLLIDED = true;
				//return true;
			//}
		//}
		//else { // COLLISION_AXIS_Y
			//var _tileSize = tilemap_get_tile_height(layer_tilemap_get_id(in.layer));
			//var _layerY = layer_get_y(in.layer);
						//
			//// Snap to position
			//if (velocity.y >= 0) { // Collided with floor
				//// Reposition to floor - fix for jittering
				//var _offsetY = bbox_bottom - y;
				//// Calculate the tile's top edge
				//var _tileTopEdge = ((in.y + _offsetY) & ~(_tileSize-1)) + _layerY;
				//// Position player on top of the tile
				//y = _tileTopEdge - _offsetY;
				//
				//// Change velocity
				//velocity.y = TILE_LAYER_DATA[$ in.layer].velocity.y;
				//
				//onGround = true;
				//groundY = y + _offsetY; // Store the ground y position correctly
				//COLLISION_FLAG_COLLIDED = true;
				//return true;
			//}
			//else { // Collided with ceiling
				//// Reposition to ceiling
				//var _offsetY = y - bbox_top;
				//// Calculate the tile's bottom edge
				//var _tileBottomEdge = ((in.y) & ~(_tileSize-1)) + _tileSize + _layerY;
				//// Position player below the tile
				//y = _tileBottomEdge + _offsetY;
				//
				//// Change velocity
				//velocity.y = TILE_LAYER_DATA[$ in.layer].velocity.y;
				//COLLISION_FLAG_COLLIDED = true;
				//return true;
			//}
		//}
	//}
	//
	//// Default return
	//return true; // Has collided
//}
//