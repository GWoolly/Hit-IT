// Macros
//=======
#macro DELTA_RATIO __deltaTime.deltaRatio


// Initialise Delta Ratio
//=======================
__deltaTime();// Starts delta_ratio updates on the global timer.
time_source_start( __deltaTime.tsDelta);// Start the global timer for DELTA_RATIO




/// @desc Updates the delta ratio per game tick. You should never have to call this function!
function __deltaTime(){
	//
	static deltaRatio= 0;
    static slomo= 1.0;
	
    static tsDelta= time_source_create(time_source_global, 1, time_source_units_frames, __deltaTime, [], -1, time_source_expire_after);
	
	/*
	static maxRatio= debug_mode? 1:	5;
	/*/
	static maxRatio= 5; // Temp
	//*/
	
	//Delta ratio with slomo applied
	deltaRatio= slomo * clamp( (delta_time / game_get_speed(gamespeed_microseconds)), 1, maxRatio); // Maxing delta ratio so that values aren't smaller than expected.
}




/**
* Sets the slow-motion speed.
* @param {real} speed	The speed at which delta is processed, where 1.0 is normal speed.
*/
function slomo(speed){
    __deltaTime.slomo= speed;
}



/// @desc Returns the slow-motion speed, where 1.0 is normal speed.
function slomo_get(){
    return __deltaTime.slomo;
}

