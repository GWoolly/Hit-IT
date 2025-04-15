/// @description Apply display settings
show_debug_message("Display: game start");

switch(OS_HANDLER_VALUE){
	case OS_HANDLER.PC: {display_set_fullscreen(display_mode); break;}
	case OS_HANDLER.GX: {
		window_set_size( width * scale, height * scale);
		window_set_fullscreen(false);
		//display_set_fullscreen(DISPLAY_MODE.WINDOW); 
		break;
	}
}
