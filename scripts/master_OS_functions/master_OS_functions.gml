__OSGetHandlerType();// Init on launch


/// @desc Gets the OS handler id for use with OS specific things.
/// @returns {real} Returns OS_HANDLER_VALUE which can be compared to OS_HANDLER.
function __OSGetHandlerType(){
	// GameMaker window functions compatibility
	//=========================================
	// Not all Platforms are compatible with gamemaker's inbuilt fullscreen and window functions.
	enum OS_HANDLER {
		NONE,
		PC,			// Windows, Mac, Linux
		//HTML5,	// Obsolete
		GX
	};
	
	#macro OS_HANDLER_VALUE __OSGetHandlerType.type
	
	static type= OS_HANDLER.NONE;

	if( type == 0){
		switch(os_type){
			case os_windows:
			case os_win8native:
			case os_linux:
			case os_macosx:
				type= OS_HANDLER.PC;
				break;
				
			case os_gxgames:
				type= OS_HANDLER.GX;
				break;
				
			case os_unknown:// Warning this could cause errors!
				type= OS_HANDLER.PC;
				break;
				
			default:
				type= OS_HANDLER.NONE
				break;
		};
		
		
		// Debug output the handler type
		//==============================
		switch(type){
			case OS_HANDLER.PC: show_debug_message($"Display: Platform handler is OS_HANDLER.PC"); break;
			case OS_HANDLER.GX: show_debug_message($"Display: Platform handler is OS_HANDLER.GX"); break;
			default: show_debug_message($"Display: Platform handler is OS_HANDLER.NONE"); break;
		}
	}
	
	return type;
}