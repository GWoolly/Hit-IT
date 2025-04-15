/// @desc Moves the calling object to a point where it no longer collides with the given collision.
/// @param {bool} collide_with  Whether to process the collision (true) or ignore it (false).
/// @param {real} distance      Distance to check for corner snapping (optional).
/// @param {real} smoothing     Smoothing factor for corner snapping (optional, default 0.75).
///
/// @returns {bool}             False, instructing the move_to_collision script to stop processing additional collisions in the current axis.
function collide_solid(collide_with = true, distance = 0, smoothing = 0.75) {

	
	var in = move_to_collision.data;
	
	if( COLLISION_IS_INSTANCE){
		
	}
	else {//COLLISION_IS_TILE
		
		
		// Get tilemap info
		var _layer= COLLISION_GET_LAYER;
		var _mapID= layer_tilemap_get_id( _layer);
		var _tileWidth= tilemap_get_tile_width(_mapID);
		var _tileHeight= tilemap_get_tile_height(_mapID);
		
		// Get layer's modulo offset
		var _layerX= layer_get_x(_layer) mod _tileWidth;
		var _layerY= layer_get_y(_layer) mod _tileHeight;
		
		
		var origin_x= x;
		var origin_y= y;
		
		var _test= (in.x & ~(_tileWidth-1)) 
		var _testL= (in.x - 4 & ~(_tileWidth-1)) 
		var _testR= (in.x + 4 & ~(_tileWidth-1)) 
		
		if(velocity.x >= 0){// Moving right
			var _offsetX= bbox_right - x;
			var _hitX= (in.x & ~(_tileWidth-1)) + _layerX - _offsetX;// Hit tile to right
		}
		else{// Moving left
			var _offsetX= x - bbox_left; 
			var _hitX= ((in.x + _offsetX) & ~(_tileWidth-1)) + _tileWidth + _layerX;// Hit tile to left
		}
		
		if(velocity.y >= 0){// Moving down
			var _offsetY= bbox_bottom - y;
			var _hitY= (in.y & ~(_tileHeight-1)) + _layerY - _offsetY;// Hit tile below
		}
		else{// Moving up
			var _offsetY= y - bbox_top; 
			var _hitY= ((in.y + _offsetY) & ~(_tileHeight-1)) + _tileHeight + _layerY +1;// Hit tile above
		}
		
		
		
		if(distance <= 0){// Move out of collision
			
			
			if( COLLISION_GET_AXIS == COLLISION_AXIS_X){
				x= _hitX;
				velocity.x= 0;
			}
			else{// COLLISION_GET_AXIS == COLLISION_AXIS_Y
				y= _hitY;
				velocity.y= 0;
			}
			
			COLLISION_FLAG_CORNER_SMOOTHING= false;
			COLLISION_FLAG_COLLIDED= true;
			return true;
			
		}
		else{// Smoothly move out of collision
			
			if( COLLISION_GET_AXIS == COLLISION_AXIS_X){// CORNER-CLIP COLLISION_AXIS_X
				
				x= _hitX;
				velocity.x= 0;
				COLLISION_FLAG_COLLIDED= true;
				return true;
			}
			else{// CORNER-CLIP COLLISION_AXIS_Y
				
				var _left= (in.x & ~(_tileWidth-1)) + _layerX - _offsetX;
				var _right= ((in.x + _offsetX) & ~(_tileWidth-1)) + _tileWidth + _layerX + 0;
				
				//instance_place_list(_left, in.y, _mapID)
				
				if( !place_meeting(_left, in.y, _mapID) && (x - _left) < distance){// Move left
					
					x= approach(x, _left, smoothing);
					velocity.x= min(velocity.x, 0);
					COLLISION_FLAG_CORNER_SMOOTHING= true;
					return false;
				}
				else if( !place_meeting(_right, in.y, _mapID) && (_right - x) < distance){// Move right
									
					x= approach(x, _right, smoothing);
					velocity.x= max(0, velocity.x);
					COLLISION_FLAG_CORNER_SMOOTHING= true;
					return false;
				}
				else{// Collide
					y= _hitY;
					velocity.y= 0;
					COLLISION_FLAG_COLLIDED= true;
					COLLISION_FLAG_CORNER_SMOOTHING= false;
					return true
				}
			}
		}
	}
	
	
	
	// Reposition - fix to avoid jittering
	var _offsetX = bbox_right - x;
	// Calculate the tile's left edge
	var _tileLeftEdge = (in.x & ~(_tileSize-1)) + _layerX;
	// Position player to the left of the tile
	x = _tileLeftEdge - _offsetX - 0;
	
	
	
	
	
	// Apply corner smoothing for all corners if distance is provided
	if (distance > 0) {
		var attempted_smoothing = false;
		var target_x = COLLISION_GET_X;
		var target_y = COLLISION_GET_Y;
		
		// Store the position we would move to without corner smoothing
		if (COLLISION_IS_INSTANCE) {
			var _inst = COLLISION_GET_ID;
			
			if (COLLISION_GET_AXIS == COLLISION_AXIS_Y) {
				var _maskOffsetY= (bbox_bottom - y) + in.y;
				
				if ((_maskOffsetY + in.y) >= _inst.bbox_bottom) { // Is underneath collision
					target_y = _inst.bbox_bottom + (y - bbox_top);
				} else { // Is standing on collision
					target_y = _inst.bbox_top - (bbox_bottom - y);
				}
			} else if (COLLISION_GET_AXIS == COLLISION_AXIS_X) {
				var _maskOffsetX= (bbox_right - x) + in.x;
				if (_maskOffsetX >= _inst.bbox_right - 1) { // Is to right of collision
					target_x = _inst.bbox_right + (x - bbox_left);
				} else { // Is to left of collision
					target_x = _inst.bbox_left - (bbox_right - x) - 0;
				}
			}
		} else { // isTile
			if (COLLISION_GET_AXIS == COLLISION_AXIS_X) {
				var _tileSize = tilemap_get_tile_width(layer_tilemap_get_id(in.layer));
				var _layerX = layer_get_x(in.layer);
				
				if (velocity.x >= 0) { // Hit solid to the right
					var _offsetX = bbox_right - x;
					var _tileLeftEdge = (in.x & ~(_tileSize-1)) + _layerX;
					target_x = _tileLeftEdge - _offsetX - 0;
				} else { // Hit solid to the left
					var _offsetX = x - bbox_left;
					var _tileRightEdge = ((in.x + _offsetX) & ~(_tileSize-1)) + _tileSize + _layerX;
					target_x = _tileRightEdge;
				}
			} else { // COLLISION_AXIS_Y
				var _tileSize = tilemap_get_tile_height(layer_tilemap_get_id(in.layer));
				var _layerY = layer_get_y(in.layer);
				
				if (velocity.y >= 0) { // Collided with floor
					var _offsetY = bbox_bottom - y;
					var _tileTopEdge = ((in.y + _offsetY) & ~(_tileSize-1)) + _layerY;
					target_y = _tileTopEdge - _offsetY;
				} else { // Collided with ceiling
					var _offsetY = y - bbox_top;
					var _tileBottomEdge = ((in.y) & ~(_tileSize-1)) + _tileSize + _layerY;
					target_y = _tileBottomEdge + _offsetY;
				}
			}
		}
		
		// Try corner smoothing based on the current axis
		if (COLLISION_GET_AXIS == COLLISION_AXIS_Y) {
			// Temporarily move to normal position to check if smoothing is possible
			var original_x = x;
			var original_y = y;
			x = target_x;
			y = target_y;
			
			var can_move_right = false;
			var can_move_left = false;
			
			if (COLLISION_IS_INSTANCE) {
				can_move_right = !place_meeting(_inst.bbox_right, in.y, COLLISION_GET_ID);
				can_move_left = !place_meeting(_inst.bbox_left, in.y, COLLISION_GET_ID);
			} else {
				var _tilemap_id = layer_tilemap_get_id(in.layer);
				
				//can_move_left= !place_meeting( & ~(_tileSize-1)), )
				//can_move_right = !tilemap_get_at_pixel(_tilemap_id, bbox_right + distance, y);
				//can_move_left = !tilemap_get_at_pixel(_tilemap_id, bbox_left - distance, y);
			}
			
			// Restore original position
			x = original_x;
			y = original_y;
			
			if (can_move_right) {
				x += min(distance, lerp(0, distance, smoothing));
				
				velocity.x = max(0, velocity.x);
				move_to_collision.stepX = max(0, move_to_collision.stepX);
				
				move_to_collision.is_smoothing_corner = true;
				COLLISION_FLAG_COLLIDED = false;
				COLLISION_FLAG_CORNER_SMOOTHING = true;
				attempted_smoothing = true;
				return false;
			}
			else if (can_move_left) {
				x -= min(distance, lerp(0, distance, smoothing));
				
				velocity.x = min(0, velocity.x);
				move_to_collision.stepX = min(0, move_to_collision.stepX);
				
				move_to_collision.is_smoothing_corner = true;
				COLLISION_FLAG_COLLIDED = false;
				COLLISION_FLAG_CORNER_SMOOTHING = true;
				attempted_smoothing = true;
				return false;
			}
		} 
		else if (COLLISION_GET_AXIS == COLLISION_AXIS_X) {
			// Temporarily move to normal position to check if smoothing is possible
			var original_x = x;
			var original_y = y;
			x = target_x;
			y = target_y;
			
			var can_move_up = false;
			var can_move_down = false;
			
			if (COLLISION_IS_INSTANCE) {
				can_move_up = !place_meeting(x, y - distance, COLLISION_GET_ID);
				can_move_down = !place_meeting(x, y + distance, COLLISION_GET_ID);
			} else {
				var _tilemap_id = layer_tilemap_get_id(in.layer);
				can_move_up = !tilemap_get_at_pixel(_tilemap_id, x, bbox_top - distance);
				can_move_down = !tilemap_get_at_pixel(_tilemap_id, x, bbox_bottom + distance);
			}
			
			// Restore original position
			x = original_x;
			y = original_y;
			
			if (can_move_up) {
				y -= min(distance, lerp(0, distance, smoothing));
				
				velocity.y = min(0, velocity.y);
				move_to_collision.stepY = min(0, move_to_collision.stepY);
				
				move_to_collision.is_smoothing_corner = true;
				COLLISION_FLAG_COLLIDED = false;
				COLLISION_FLAG_CORNER_SMOOTHING = true;
				attempted_smoothing = true;
				return false;
			}
			else if (can_move_down) {
				y += min(distance, lerp(0, distance, smoothing));
				
				velocity.y = max(0, velocity.y);
				move_to_collision.stepY = max(0, move_to_collision.stepY);
				
				move_to_collision.is_smoothing_corner = true;
				COLLISION_FLAG_COLLIDED = false;
				COLLISION_FLAG_CORNER_SMOOTHING = true;
				attempted_smoothing = true;
				return false;
			}
		}
		
		// If we attempted to smooth but couldn't, proceed with normal collision
		if (!attempted_smoothing) {
			COLLISION_FLAG_CORNER_SMOOTHING = false;
		}
	}
	
	// If corner smoothing didn't occur or wasn't attempted, proceed with normal solid collision
	if (COLLISION_IS_INSTANCE) {
		var _inst = COLLISION_GET_ID;
		
		switch (COLLISION_GET_AXIS) {
			case COLLISION_AXIS_Y:
				if (bbox_bottom >= _inst.bbox_bottom) { // Is underneath collision
					var _targetY = _inst.bbox_bottom + (y - bbox_top);
					y = _targetY;
					velocity.y = max(0, _inst.velocity.y);
					COLLISION_FLAG_COLLIDED = true;
					return true;
				}
				else { // Is standing on collision
					y = _inst.bbox_top - (bbox_bottom - y);
					velocity.y = min(0, _inst.velocity.y);
					
					groundY = _inst.bbox_top;
					onGround = true;
					COLLISION_FLAG_COLLIDED = true;
					return true;
				}
			case COLLISION_AXIS_X:
				if (bbox_left >= _inst.bbox_right - 1) { // Is to right of collision
					x = _inst.bbox_right + (x - bbox_left);
					velocity.x = max(0, _inst.velocity.x);
					COLLISION_FLAG_COLLIDED = true;
					return true;
				}
				else { // Is to left of collision
					x = _inst.bbox_left - (bbox_right - x) - 0;
					velocity.x = min(0, velocity.x);
					COLLISION_FLAG_COLLIDED = true;
					return true;
				}
			default: // Exception
				COLLISION_FLAG_COLLIDED = false;
				return false;
		}
	}
	else { // isTile
		if (COLLISION_GET_AXIS == COLLISION_AXIS_X) {
			var _tileSize = tilemap_get_tile_width(layer_tilemap_get_id(in.layer));
						
			if (velocity.x >= 0) { // Hit solid to the right
				var _layerX = layer_get_x(in.layer);
				
				// Reposition - fix to avoid jittering
				var _offsetX = bbox_right - x;
				// Calculate the tile's left edge
				var _tileLeftEdge = (in.x & ~(_tileSize-1)) + _layerX;
				// Position player to the left of the tile
				x = _tileLeftEdge - _offsetX - 0;
				
				// Change velocity
				velocity.x = 0;
				COLLISION_FLAG_COLLIDED = true;
				return true;
			}
			else { // Hit solid to the left
				var _layerX = layer_get_x(in.layer);
				
				// Reposition - fix to avoid jittering
				var _offsetX = x - bbox_left;
				// Calculate the tile's right edge
				var _tileRightEdge = ((in.x + _offsetX) & ~(_tileSize-1)) + _tileSize + _layerX;
				// Position player to the right of the tile
				x = _tileRightEdge;
				
				// Change velocity
				velocity.x = 0;
				COLLISION_FLAG_COLLIDED = true;
				return true;
			}
		}
		else { // COLLISION_AXIS_Y
			var _tileSize = tilemap_get_tile_height(layer_tilemap_get_id(in.layer));
			var _layerY = layer_get_y(in.layer);
						
			// Snap to position
			if (velocity.y >= 0) { // Collided with floor
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
				COLLISION_FLAG_COLLIDED = true;
				return true;
			}
			else { // Collided with ceiling
				// Reposition to ceiling
				var _offsetY = y - bbox_top;
				// Calculate the tile's bottom edge
				var _tileBottomEdge = ((in.y) & ~(_tileSize-1)) + _tileSize + _layerY;
				// Position player below the tile
				y = _tileBottomEdge + _offsetY;
				
				// Change velocity
				velocity.y = TILE_LAYER_DATA[$ in.layer].velocity.y;
				COLLISION_FLAG_COLLIDED = true;
				return true;
			}
		}
	}
	
	// Default return
	return true; // Has collided
}



