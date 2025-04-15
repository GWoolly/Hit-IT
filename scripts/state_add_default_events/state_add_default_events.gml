/// @desc Adds default events to the state machine's state struct.
/// @param {struct} stateStruct				Root state struct of the state machine.
/// @param {struct} [defaultEventStruct]	Default events to add to the stateStruct.
/// @returns {struct}	Appended stateStruct.
function state_add_default_events(stateStruct, defaultEventStruct= undefined){
	
	// Default events if undefined
	defaultEventStruct ??= {
			enter: function(){},
			leave: function(){},
			step: function(){},
	};
	
	
	var _states= struct_get_names(stateStruct);
	var _events= struct_get_names(defaultEventStruct);
	
	// Check individual states
	for(var iState= array_length(_states)-1;	iState >= 0;	iState--){
		
		var _thisState= stateStruct[$ _states[iState]];	// Current state struct being checked.
		
		
		// Check current state struct for unique event functions, if not add them.
		for(var iEvent= array_length(_events)-1;		iEvent >= 0;	iEvent--){
			
			var _eventName= _events[iEvent];// Current event's name
			
			// Add default value to struct if not present
			if( struct_exists(_thisState, _eventName)	== false){
				struct_set(_thisState, _eventName, defaultEventStruct[$ _eventName] )
			}
		}
	}
	
	return stateStruct;
}