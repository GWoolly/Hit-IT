/// @desc Returns an array of the unique id's of a given array of layers given as strings.
/// @param {array} layer_names_array An array of layers as strings.
/// @returns {array} Array of layer ids.
function layers_get_ids(layer_names_array){
	
	for(var i= array_length(layer_names_array)-1;	i >= 0;		i--){
		
		var _layer= layer_names_array[i];
		if( is_string(_layer)){
			layer_names_array[@ i]= layer_get_id(_layer);
		}
	}
	return layer_names_array;
}