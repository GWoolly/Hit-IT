/**
 * Draws the surface of the specified camera, from the top left corner of the given coordinates.
 * @param {real} view	The view id that the camera is assigned to.
 * @param {real} x		The x position of where to draw the surface.
 * @param {real} y		The y position of where to draw the surface.
 */
function camera_draw_surface(view, x= 0, y= 0){
	if(view_visible[view] == true){
		var _camera= global.cameraList[view];
		//draw_surface_ext(_camera.surface.id, x,y, _camera.draw_scale, _camera.draw_scale, 0.0, c_white, 1.0);
		
		var _ux= frac(_camera.x);
		var _uy= frac(_camera.y);
        var _surfaceWidth= surface_get_width(view_surface_id[view]);
        var _surfaceHeight= surface_get_height(view_surface_id[view]);
		draw_surface_part_ext(view_surface_id[view], _ux, _uy, _surfaceWidth, _surfaceHeight, 0, 0, _camera.draw_scale, _camera.draw_scale, c_white, 1.0);
	}
}




/**
 * Regenerates the surface for the camera with the current display settings. This should be called whenever the camera's surface is lost within the Pre-Draw event.
 */
function camera_regenerate_surface(){
    
    if(surface_exists(view_surface_id[view_index]) == true){
        surface_free(view_surface_id[view_index]);
    }
    
    if(dynamic_quality == true){// Best quality for games
        surface= surface_create( (GAME_SCALE * width) * quality, (GAME_SCALE * height) * quality);
        view_surface_id[view_index]= surface;
        draw_scale= 1 / quality;
    }
    else{// Pixel perfect games - but may cause jitteriness!
        surface= surface_create( width * quality, height * quality);
        view_surface_id[view_index]= surface;
        draw_scale= GAME_SCALE / quality;
    }
}