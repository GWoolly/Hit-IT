/// @description Enable views
view_enabled= true;




// Create camera
//==============
if(instance_exists(oCamera) == false){
	instance_create_layer(0,0, layer, oCamera);
}