/// @description 

switch(OS_HANDLER_VALUE){
	case OS_HANDLER.GX:{
		
		//Fullscreen state has changed
		//============================
		if( fullscreen!= window_get_fullscreen()){
			show_debug_message($"DisplayManager:: Fullscreen state has changed from {fullscreen} -> {window_get_fullscreen()}")
			
			if(window_get_fullscreen() == true){
				display_set_scale(-1);
			}
			else{
				display_set_scale(DISPLAY_WINDOW.scale);
			}
			
			fullscreen= window_get_fullscreen();
		}
		
		//Request fullscreen toggle
		if(keyboard_check_pressed(vk_f4)){
			window_set_fullscreen( !window_get_fullscreen());
		}
		
		break;
	}
}


//Change the scale - Debug
//========================
var _scale = keyboard_check_released(187) - keyboard_check_released(189);
if(_scale != 0){
	scale += _scale;
	display_set_scale(scale);
}