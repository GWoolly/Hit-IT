/// @description Initialise the game
force_single_instance();


// Initialise these objects on launch
//===================================
init_objects_array= [
	oTilemapManager
];
for(var i=0, iEnd= array_length(init_objects_array);	i < iEnd;	i++){
	var _inst= instance_create_layer(0,0, layer, init_objects_array[i]);
	show_debug_message($"Init:: Created: {_inst} - {object_get_name(_inst.object_index)}");
}
