/// @desc Centers the game window on the screen.
function display_window_center(){	
    with(oDisplayManager){
        switch(platformHandler){
            case PLATFORM_HANDLER.PC:{
                // Timer to callback this function when changing display modes.
                static attempt= 0;
                static timer= time_source_create(time_source_global, DISPLAY_FULLSCREEN_POST_DELAY_SECS, time_source_units_seconds, display_window_center, [], DISPLAY_WINDOW_CENTER_MAX_ATTEMPTS);
                
                
                // Attempt to center the screen
                //=============================
                
                if(attempt==0){
                    display_fetch_info();
                    
                    // Get coords for Window Center
                    window.x= floor((display.x + (display.width * 0.5)) - (0.5 * ( scale * width)) );
                    window.y= floor((display.y + (display.height * 0.5)) - (0.5 *  (scale * height)) );
                    
                    // Schedule the window to be centered if the window's size has been changed
                    window_set_position(window.x, window.y)
                    time_source_reset(timer);
                    time_source_start(timer);
                    attempt++;
                    
                }
                else if(window_get_x() == window.x	&&	window_get_y() == window.y ){// Window is centered
                    
                    time_source_stop(timer);
                    show_debug_message($"display_window_center() finished after attempt {attempt}.")
                    attempt=0;
                    
                }
                else if( attempt == DISPLAY_WINDOW_CENTER_MAX_ATTEMPTS){
                    show_debug_message($"display_window_center() failed after {attempt} attempts. x: {window_get_x()} != {window.x}, y: {window_get_y()} != {window.y}.")
                    attempt=0;
                }
                else{// Reattempt to center the window
                    window_set_position(window.x, window.y)
                    attempt++;
                }
                
                
                break;
            }	
        
        }//switch(platformHandler)
    }
}





/// @desc Sets the scale of the game's window or fullscreen render scale.
/// @param {real} new_scale	The scale to render the game at. When set to false, the maximum scale is used for the dimensions of the display or browser.
function display_set_scale(new_scale, integer_scaling= true){
    
    DISPLAY_INFO= new display_fetch_info(); 
    
    //Get new scale
    //=============
    GAME_SCALE= (new_scale < 0)? DISPLAY_INFO.scaleMax	: clamp(new_scale, 1, DISPLAY_INFO.scaleMax);
    GAME_SCALE= (integer_scaling == true)?	floor(GAME_SCALE) : GAME_SCALE;
    
    
    // Get new resolution
    //===================
    var _x, _y, _width, _height;
    if(GAME_ASPECT_RATIO > 0){// Landscape game
            
        _height= GAME_HEIGHT * GAME_SCALE;
        _width= floor(_height * GAME_ASPECT_RATIO);
    }
    else{//Portrait game
        
        _width=	GAME_WIDTH * GAME_SCALE;
        _height= floor(_width / GAME_ASPECT_RATIO);
    }
    
    // Update the GUI size to fit
    display_set_gui_size(_width, _height)
    
    
    //Update all cameras to match new scale
    //=====================================
    with(oCamera){
        camera_regenerate_surface()
    }
    
    //if( variable_global_exists("cameraList") == true){
        //for(var i= array_length(global.cameraList) - 1;		i >= 0;		i--){
            //with(global.cameraList[i]){
                //draw_scale= quality * GAME_SCALE;
            //}
        //}
    //}
    //else{
        //global.cameraList= [];
    //}
    
    // OS Handling
    switch( OS_HANDLER_VALUE){
        case OS_HANDLER.PC:{
            
            // Window / fullscreen rendering offset
            _x= DISPLAY_INFO.x + (DISPLAY_INFO.width * 0.5) - (_width * 0.5);
            _y= DISPLAY_INFO.y + (DISPLAY_INFO.height * 0.5) - (_height * 0.5);
            
            // Update based on fullscreen mode
            //================================
            if( window_get_fullscreen() == false){//Windowed
                
                window_set_rectangle(_x, _y, _width, _height);
                display_set_gui_maximize(1.0, 1.0, 0, 0);
                
                // Update the app window size and position
                DISPLAY_WINDOW.x= _x;
                DISPLAY_WINDOW.y= _y;
                DISPLAY_WINDOW.width= _width;
                DISPLAY_WINDOW.height= _height;
            }
            else{// Fullscreen
                
                display_set_gui_maximize(1.0, 1.0, _x, _y);
            }
        }
        case OS_HANDLER.GX:{
            
            // Bug with not rendering game central in full screen when you first switch
            display_set_gui_maximize(1.0, 1.0, 0, 0);
            window_set_size(_width, _height);
        }
    }
    
    
    // Update application surface if enabled
    //======================================
    if(	application_surface_is_enabled()
    &&	surface_exists(application_surface)){
        surface_resize(application_surface, _width, _height);
    }
    
}




/// @desc  Sets the display mode including borderless fullscreen
/// @param {real} displayMode  Sets the display_mode based on the given DISPLAY_MODE enum value. A positive or negative value outside of range will loop around to the next value listed in the enum.
function display_set_fullscreen(fullscreen=undefined, borderless= false){	
    enum FULLSCREEN{
        FALSE,	
        TRUE,	
        BORDERLESS,
    }
    
    // Statics
    static value_fullscreen= false;
    static value_borderless= false;
    
    //Time Source callback for borderless fullscreen
    //==============================================
    static callback= function(is_borderless){
        var _timer= display_set_fullscreen.timer;
        
        if( window_get_borderless_fullscreen() != is_borderless){
            window_enable_borderless_fullscreen(is_borderless);
        }
        else{
            time_source_stop(_timer);
        }
        
        // Error out
        if( time_source_get_reps_remaining(_timer) == 0){
            show_debug_message($"display_set_fullscreen:: Failed after {time_source_get_reps_completed(_timer)} attempts.")
        }
    };
    static timer= time_source_create(time_source_global, 1, time_source_units_frames, callback, [value_borderless], 5);
    
    
    // Begin changing the fullscreen state
    //====================================
    fullscreen= modulo(fullscreen, 3)
    
    switch(OS_HANDLER_VALUE){
        case OS_HANDLER.GX:{
            
            // Get requested fullscreen value
            if( fullscreen == undefined){
                fullscreen= !window_get_fullscreen();
            }
            else{
                fullscreen= fullscreen > 0;
            }
            
            
            DISPLAY_INFO= new display_fetch_info();
            
            //Store current window scale
            if(window_get_fullscreen() == false){
                show_debug_message($"display_set_fullscreen({fullscreen}):: Window scale= {DISPLAY_WINDOW.scale} -> {GAME_SCALE}")
                DISPLAY_WINDOW.scale= GAME_SCALE;
            }
            
            // Change the display mode
            //========================
            window_set_fullscreen( fullscreen);
            // Scaling is handled in the Begin-Step event
            
            break;
        }
        case OS_HANDLER.PC:{
            
            fullscreen??= !window_get_fullscreen();
            DISPLAY_INFO= new display_fetch_info();
            
            
            // Store window postion
            if(window_get_fullscreen() == false){
                
                //Store old window data
                DISPLAY_WINDOW.x= window_get_x();
                DISPLAY_WINDOW.y= window_get_y();
                DISPLAY_WINDOW.width= window_get_width();
                DISPLAY_WINDOW.height= window_get_height();
                
                DISPLAY_WINDOW.scale= GAME_SCALE;
            }		
            
            
            //Change the display mode
            window_set_fullscreen( fullscreen > 0);
            window_enable_borderless_fullscreen( (fullscreen >> 1) || borderless);
            
            //Allow borderless
            time_source_reset(timer);
            time_source_start(timer);
            
            //Change scale and recenter
            //=========================
            if( fullscreen > 0){// Is fullscreen
                display_set_scale(-1);
            }
            else{//Windowed
                display_set_scale( DISPLAY_WINDOW.scale);
                window_set_rectangle(DISPLAY_WINDOW.x, DISPLAY_WINDOW.y, DISPLAY_WINDOW.width, DISPLAY_WINDOW.height);
            }
        }
    }
    
}





/// @desc  Fetchs the information of the display that the game is being played on.
/// @returns {struct} Struct of the display that the game is running on.
function display_fetch_info() constructor{
	switch(OS_HANDLER_VALUE){
		case OS_HANDLER.PC:{
			
			// Get the center-point of the window
			//===================================
			var _winX= window_get_x() + (0.5 * ( GAME_SCALE * GAME_WIDTH));
			var _winY= window_get_y() + (0.5 * ( GAME_SCALE * GAME_HEIGHT));
			
			var _rects= window_get_visible_rects(_winX, _winY, _winX, _winY);
			var _x1, _y1, _x2, _y2;
			
			//Get best display
			for(var i=array_length(_rects) - 8;		i >= 0;		i-= 8){
				_x1= _rects[i+4];
				_y1= _rects[i+5];
				_x2= _rects[i+6];
				_y2= _rects[i+7];
				
				if( point_in_rectangle(_winX, _winY, _x1, _y1, _x2, _y2) == true){
					index= i div 8;
					break;
				}
			}
			
			// Display config
			//===============
			index??= 0;							// Index of the display the game is being shown on
			count= array_length(_rects) div 8;	// Number of attached displays
				
			x=		_x1;
			y=		_y1;
			width=	_x2 - _x1;
			height= _y2 - _y1;
			
			aspectRatio= width / height;
			scaleMax= (aspectRatio > 0)?	/*Landscape*/(height / GAME_HEIGHT)	:	/*Portrait*/(width / GAME_WIDTH);	//Get max scale that can fit within the screen's resolution.
			break;
		}	
		case OS_HANDLER.GX:{
			width= browser_width;
			height= browser_height;
			aspectRatio= width / height;
			scaleMax= (aspectRatio > 0)?	/*Landscape*/(height / GAME_HEIGHT)	:	/*Portrait*/(width / GAME_WIDTH);	//Get max scale that can fit within the screen's resolution
			break;
		}		
		default:{
			break;
		}
	}
	
}




