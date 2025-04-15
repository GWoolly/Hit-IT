/// @description NOOP was Pre-draw Regenerate view surface


exit;

//if(live_call()){return live_result;}

//*/
show_debug_message($"{object_get_name(object_index)}: draw begin - post gmlive");
// Recreate view surface
//======================
if(surface_exists(CAMERA_SURFACE )==false){
	CAMERA_SURFACE= surface_create(width*quality, height*quality);
}

show_debug_message($"{object_get_name(object_index)}: draw begin - surf check");

surface_set_target(CAMERA_SURFACE)

	draw_clear_alpha(c_black, 0.0);
	
surface_reset_target()
show_debug_message($"{object_get_name(object_index)}: draw begin - done");


/*/
if(surface_exists(surface)==false){
	surface= surface_create(width, height)
	view_surface_id[view]=surface;
	
	surface_set_target(surface)
	draw_clear(c_black);
surface_reset_target()
}
//*/

