function state_methodise_all(){
	var _me = self.state.owner;
		
	var _states= struct_get_names(self.states);
	for(var i=array_length(_states)-1;	i >= 0;		i--){
		
		var _keys= struct_get_names(self.states[$ _states[i]]);
		for(var ii=array_length(_keys)-1;	ii >= 0;		ii--){
			var _event = self.states[$ _states[i]][$ _keys[ii]];
			
			//Ignore name of state
			if(is_string(_event) == false){
				self.states[$ _states[i]][$ _keys[ii]]= method(self.state.owner, _event);
			}
		}
	}
}