function tilemap_collision_list(tilemap_id, left=bbox_left, top=bbox_top, right=bbox_right, bottom=bbox_bottom,dirX=1, dirY=1){
	static arrayCollisions= [];
	
	
	// Get tile size
	var _tileWidth = tilemap_get_tile_width(tilemap_id);
	var _tileHeight = tilemap_get_tile_height(tilemap_id);
	
	var iy, iyEnd, iyStep, ix, ixEnd, ixStep;
	
	if(dirY >= 0){//Check bottom up
		iy= bottom;
		iyEnd= top;
		iyStep= -_tileHeight;
	}
	else{//Check top to bottom
		iy= top;
		iyEnd= bottom;
		iyStep= _tileHeight
	}
	
	if(dirX >= 0){//Check bottom up
		ix= bottom;
		ixEnd= top;
		ixStep= -_tileWidth;
	}
	else{//Check top to bottom
		ix= top;
		ixEnd= bottom;
		ixStep= _tileWidth;
	}
	
	
	//Clear old collisions
	//====================
	array_resize(arrayCollisions, 0);
	
	
	//Check 2D grid
	//=============
	for(iy=iy;		abs(iy) <= abs(iyEnd);		iy+= iyStep){
		for(ix=ix;		abs(ix) <= abs(ixEnd);		ix+= ixStep){
			
			var _elem= tilemap_get_at_pixel(tilemap_id, ix, iy);
			
			if(_elem > 0){// Found tile!
				array_push(arrayCollisions, _elem);
			}
		}
	}
	
	return arrayCollisions;
}