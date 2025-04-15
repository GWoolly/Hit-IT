//#macro state_add with state_define

function state_define(_name, _defaultEvents=state_machine_default_events){
	
	if(variable_struct_exists(self, "states") == false){
		struct_set(self, "states", {});
	}
	
	self.states[$ _name]= new _defaultEvents();
	self.states[$ _name].name= _name; 
	return self.states[$_name];
}