/// @desc Constructs a finite-state-machine, based on SnowState.
/// @param {struct}	statesStruct	Struct containing all states.
/// @param {string}	initialState	String-name of the initial state.
/// @param {bool}	doEnter			Performs the event.enter function when true.
function state_machine_create(statesStruct, initialState= undefined, doEnter= true) constructor{
	
	// Functions
	//==========
	
	/// @desc Changes the current state to a new one.
	/// @param {string} newState	String-name of a state within the states-struct.
	/// @param {bool}	doEnter		Performs the event.enter function when true.
	/// @param {bool}	doLeave		Performs the event.leave function when true.
	set= function(newState, doEnter=true, doLeave=true){
		// Perform Leave Event
		if(doLeave== true){ self.event.leave();}
		
		// Change State
		self.event= self.states[$ newState];
		self.name= newState;
		
		// Add new state to history
		if(STATE_HISTORY_ENABLE == true){
			
			array_push(self.history, newState);
			
			// Remove older history
			if(array_length(self.history) > STATE_HISTORY_MAX){
				array_pop(self.history);
			}
		}
		
		
		// Perform Enter Event
		if(doEnter == true){ self.event.enter();}
	};
	
	
	
	// Variables and structs
	//======================
		
	owner= other.id;	// Calling instance
	currentState= "";	// Current state's name
	self.initialState= initialState;
	
	states= statesStruct;	//Pre-populating the states is recommended for speed and reliability.
	
	
	
	// Init state has No-Op events to prevent potential errors.
	event= {
		enter: function(){},
		step: function(){},
		leave: function(){},
	};
	
	
	//Add history if enabled.
	if( STATE_HISTORY_ENABLE == true){
		history= [];
	}
	
	// Methodise all nested functions within all states.
	//==================================================
	var _stateNames= struct_get_names(states);
	for(var i=array_length(_stateNames)-1;	i >= 0;		i--){
		
		// Methodise the current state's event functions.
		var _stateEvents= struct_get_names(states[$ _stateNames[i]]);
		for(var ii=array_length(_stateEvents)-1;	ii >= 0;		ii--){
			
			// Methodise the event
			if(is_string(self.states[$ _stateNames[i]][$ _stateEvents[ii]]) == false){//Ignore keys with other data.
				states[$ _stateNames[i]][$ _stateEvents[ii]]= method(other.id, states[$ _stateNames[i]][$ _stateEvents[ii]]);
			}
		}
	}
	
	
	
	// Finally set the initial state
	//==============================
	if( initialState != undefined){
		self.set(initialState, doEnter, false);
	}
}