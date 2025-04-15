/// @description Re-create GUI surface
//if(live_call()){return live_result;}


// Check if surface exists, if not recreate it.
if(surface_exists(surfaceGUI.surface) == false){
	surfaceGUI.surface = surface_create(surfaceGUI.width, surfaceGUI.height);
}


// Pre-draw Shaders
//=================
//gfxPixelUpscaler(surface_get_texture(surfaceGUI.id), game.scale)