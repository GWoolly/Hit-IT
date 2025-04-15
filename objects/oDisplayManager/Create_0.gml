/// Initialise Display Manager
///===========================
// Force single instance
force_single_instance();
show_debug_message("oDisplayManager:: Create event.")

/* Set the game's default native resolution
 * ========================================
 * Default configuration can be found within the Variable Definitions
 *
 * @var {string} init_resolution	Defines where the default game resolution values should be taken from.
 *									- Variable Definition: Takes the width and height values from the variable definition.
 *									- Object Scale: The width and height is defined by the box-boundary of the object's scale. The scale is multiplied by 10, so an image_scale of 16.0 by 14.4 with have a native resolution of 160 by 144 pixels.
 *									- Room Size: Uses the size of the room to set the game's native resolution.
 *
 * You can define or import alternative values for the following variables after the switch statement, 
 * but before the display manager begins initialisation.
 *
 * @var {number}	width	Game's native resolution for width.
 * @var {number}	height	Game's native resolution for height.
 * @var {float}		scale	Window scale, does not affect resolution.
 * @var {number}	display_mode		What mode to start the game in.
 */



switch(init_resolution){
	case "Object Scale":{
		width= image_xscale * sprite_width;
		height= image_yscale * sprite_height;
		break;
	}
	
	case "Room Size":{
		width= room_width;
		height= room_height;
		break;
	}
	
	case "Variable Definition":{
		break;
	}
	default:{// Create Event
		width=	160;
		height=	144;
	}
}



// Load an imported display config here
//=====================================





#region Initialise the Display Manager's Variables
//================================================

// Game Native Resolution
//=======================
width= floor(width);
height= floor(height);
aspectRatio= width / height;
scale= scale;

// Macros of Game's native resoltion variables
#macro GAME_WIDTH oDisplayManager.width
#macro GAME_HEIGHT oDisplayManager.height
#macro GAME_SCALE oDisplayManager.scale
#macro GAME_ASPECT_RATIO oDisplayManager.aspectRatio

#macro DISPLAY_INFO oDisplayManager.display /* Info about the display the game is being displayed on. */
#macro DISPLAY_WINDOW oDisplayManager.window/* Info about the window the game is being displayed on. */

global.cameraList = [];


// Get the platform handler
//=========================

#endregion

switch(OS_HANDLER_VALUE){
	case OS_HANDLER.GX:{
		window={
				x: window_get_x(),
				y: window_get_y(),
				
				width: width * scale,
				height: height * scale,
				
				scale: GAME_SCALE,
		};
		display= new display_fetch_info();
		fullscreen= false;// Used in GX for fullscreen on change
		break;
	}
	
	case OS_HANDLER.PC:{
		window={
				x: window_get_x(),
				y: window_get_y(),
				
				width: width * scale,
				height: height * scale,
				
				scale: GAME_SCALE,
		};
		display= new display_fetch_info()
		
		
		display_set_fullscreen(display_mode)
		break;
	}
}



#region Camera Manager Variables

//var _views = 8

//repeat( _views){
	
//	global.cameraList[--_views] = {
//		active: ptr(view_visible[_views]),		// Camera and view is active
//		camera: ptr(view_camera[_views]),		// The camera's id
//		surface: ptr(view_surface_id[_views]),	// Surface id
//	};
//}

#endregion



// Create HTML5 clickable for fullscreen toggling
//===============================================
//if( platformHandler == OS_HANDLER.GX){
	
//	var _sprClickable= sprClickableFullscreen;
//	var _offset = 2;
	
//	//Temp disabled
//	//html5_clickable_fullscreen_add(window_get_width() - sprite_get_width(_sprClickable), window_get_height() + _offset, sprClickableFullscreen);
//}




//  Disable application surface.
//==============================
// We don't need the Application Surface as the camera system uses individual surfaces.
application_surface_enable(false);
if( application_surface_is_enabled() == false){
	
	application_surface_draw_enable(false);
	
	if( surface_exists(application_surface) ){
		surface_free(application_surface);
	}
}



// GUI Layer surface
//==================
// I prefer my GUI to be drawn to a surface for shader compatibility.
surfaceGUI = {
	surface: surface_create(display.width, display.height),
	width: display.width, 
	height: display.height,
};



// Initialise the display manager
//===============================
//display_init(width , height, max(1, scale), fullscreen_mode & DISPLAY_MODE.FULLSCREEN, fullscreen_mode & DISPLAY_MODE.FULLSCREEN_BORDERLESS)


// GUI
//=====
//surfaceGUI = new safe_surface_struct(display.width, display.height,, "GUI");





// vv  Insert your code below  vv
//===============================


//mode = 0;

show_debug_message($"display_mode= {display_mode}")