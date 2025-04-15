// @description Recreate camera surface when lost
if(surface_exists(view_surface_id[view_index]) == false){
    camera_regenerate_surface()
}

//Clear the surface
surface_set_target(view_surface_id[view_index])
draw_clear_alpha(c_lime, 1.0);
surface_reset_target();