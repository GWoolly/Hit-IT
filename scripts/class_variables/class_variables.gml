#macro CLASS_VARIABLES if(live_call()){return live_result;} __class_variables
function __class_variables( struct){
	struct_foreach(struct, function(_name, _value){
		self[$ _name]= _value;
	});
	sequence_destroy(struct);
}