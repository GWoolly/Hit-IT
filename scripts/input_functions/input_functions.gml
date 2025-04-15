function input_create(bindings_struct, player_id= 0) constructor{
	
	// Store the bindings
	//===================
	self.player_id= player_id;
	
	bindings= bindings_struct;
	deviceName= "keyboard";
	gamepadID= noone;
	
	
	// Macros - Because I hate the ambiguity of gp_face!
	#macro gp_faced gp_face1
	#macro gp_facel gp_face3
	#macro gp_faceu gp_face4
	#macro gp_facer gp_face2
	
    #macro GAMEPAD_BLACKLIST ["Nintendo Switch Pro Controller"] /*Buggy directX input*/
    
    static gamepadBlacklist= array_create(gamepad_get_device_count(), false);
    
	/**
	 * Bind a device's input to a verb
	 *
	 * @param {string} device	Parent struct for the device getting the binding.
	 * @param {string} verb		The action verb the input is assigned to.
	 * @param {any*} input		The input assigned to this binding.
	 */
	static bind= function(device, verb, input){
		self.bindings[$ device][$ verb]= input;
	};
	
	
	
	/**
	 * Return whether a binding exists for the specified device type.
	 *
	 * @param {string} device	The device type as a string.
	 * @param {string} verb		The verb as a string.
	 */
	static binding_exists= function(device, verb){
		return variable_struct_exists(self.bindings[$ device], verb);
	}
	
	/**
	 * Unbinds a verb from a device.
	 *
	 * @param {string} device	The input device to remove the verb from.
	 * @param {string} verb		The verb to be removed.
	 */
	static unbind= function(device, verb){
		if( self.binding_exists(device, verb) == true){
			variable_struct_remove(self.bindings[$ device], verb);
		}
	};
	
	
	
	/**
	 * Checks if the input of the specified verb is active.
	 *
	 * @param {string} verb		The verb to get the input of.
	 * @returns {bool}			If the button or key is actively being pressed.
	 */
	static check_button= function(verb){
		
		if( binding_exists(deviceName, verb) == false){
			show_debug_message($"input:: No such binding exists for player[{player_id}].bindings.{deviceName}.{verb}");
			return false;
		}
		else{
			var _value= 0;
            var _button= self.bindings[$ self.deviceName][$ verb];
            
            //Convert to array
            if( is_array(_button) == false){
                _button= [_button];
            }
            
			switch(self.deviceName){
				case "keyboard": 
                    for(var i= array_length(_button)-1;    i >= 0;     i--){
                        _value += keyboard_check(_button[i]);
                    }
                    break;
				case "gamepad":
                    for(var i= array_length(_button)-1;    i >= 0;     i--){
                        _value += gamepad_button_check(self.gamepadID, _button[i]);
                    }
                    break;
                default: return false;
			}
            
            return _value > 0;
		}
	};
	

	/**
	 * Checks if the input of the specified verb has just been pressed.
	 *
	 * @param {string} verb		The verb to get the input of.
	 * @returns {bool}			If the button or key was just pressed.
	 */
	static check_button_pressed= function(verb){
		
		if( binding_exists(deviceName, verb) == false){
			show_debug_message($"input:: No such binding exists for player[{player_id}].bindings.{deviceName}.{verb}");
			return false;
		}
		else{
			var _value= 0;
            var _button= self.bindings[$ self.deviceName][$ verb];
            
            //Convert to array
            if( is_array(_button) == false){
                _button= [_button];
            }
            
			switch(self.deviceName){
				case "keyboard": 
                    for(var i= array_length(_button)-1;    i >= 0;     i--){
                        _value+= keyboard_check_pressed(_button[i]);
                    }
                    break;
				case "gamepad":
                    for(var i= array_length(_button)-1;    i >= 0;     i--){
                        _value+= gamepad_button_check_pressed(self.gamepadID, _button[i]);
                    }
                    break;
                default: return false;
			}
            
            return _value > 0;
		}
	};
	
	
	/**
	 * Checks if the input of the specified verb was just released.
	 * @param {string} verb		The verb to get the input of.
	 * @returns {bool}			If the button or key was just released.
	 */
	static check_button_released= function(verb){
		
		if( binding_exists(deviceName, verb) == false){
			show_debug_message($"input:: No such binding exists for player[{player_id}].bindings.{deviceName}.{verb}");
			return false;
		}
		else{
			var _button= self.bindings[$ self.deviceName][$ verb];
			switch(self.deviceName){
				case "keyboard": return keyboard_check_released(_button);
				case "gamepad": return gamepad_button_check_released(self.gamepadID, _button);
			}
		}
	};
	
	/**
	 * Checks if the axial input of the specified verb.
	 * @param {string} verb		The verb to get the input axis of.
	 * @returns {real}			Current value of the axis.
	 */
	static check_axis= function(verb){
		
		if( binding_exists(deviceName, verb) == false){
			//show_debug_message($"input:: No such binding exists for player[{player_id}].bindings.{deviceName}.{verb}");
			return 0;
		}
		else{
			var _axis= self.bindings[$ self.deviceName][$ verb];
			switch(self.deviceName){
				case "keyboard": return 0;
				case "gamepad": return gamepad_axis_value(self.gamepadID, _axis);
			}
		}
	};
	
	
	/**
	 *	Checks to see if the player has swapped devices.
	 */
	static update_device= function(){
		
        
        
        
        var _hasSwapped= false;
        
		if(self.gamepadID == noone
		|| gamepad_is_connected(self.gamepadID) == false){
			// Check gamepads for input
			//=========================
			var _maxGamepads= gamepad_get_device_count();
			for(var i= 0; i < _maxGamepads; i++){
				
				if(gamepad_is_connected(i) == true){
					
                    //Direct Input device error checking
                    var _gamepadName= gamepad_get_description(i);
                    
                    var _test= GAMEPAD_BLACKLIST
                    var _test2= input_create.gamepadBlacklist;
                    
                    
                    if(input_create.gamepadBlacklist[i] == true){ continue;}// Skip blacklisted gamepad
                    
                    //Blacklist gamepad from connecting
                    if( i > 3 // In Direct-X input range
                    && array_contains(GAMEPAD_BLACKLIST, _gamepadName) > 0){
                        
                        //if(input_create.gamepadBlacklist[i] == false)){
                            show_debug_message($"input.update_device:: Warning incompatible gamepad[{i}] '{_gamepadName}' was detected!");
                            input_create.gamepadBlacklist[i]= true;
                            continue;
                        //}
                    }
                    
					for(var b= gp_face1; b <= gp_padr; b++){
						if( gamepad_button_check(i, b) == true){
							self.deviceName= "gamepad";
							self.gamepadID= i;
                            gamepad_set_axis_deadzone(i, bindings.gamepad.deadzone);
							_hasSwapped= true;
							break;// Switch to first detected gamepad - Will need to alter this if multiplayer!
						}
						else{
							continue;
						}
					}
				}
			}
		}
		
		// Check keyboard for input
		//=========================
		if(keyboard_check( vk_anykey) == true){
			self.deviceName= "keyboard";
			
			if(self.gamepadID != noone){
				self.gamepadID= noone;// Reset gamepad ID as it's not being used.
				_hasSwapped= true;
			}
		}
	};
	
	
	
	
	
	
	
	//gamepad_assign= function(gamepad_index){
	//	gamepadID= gamepad_index;
	//}
	
	
	//input_change_device= function(){
		
	//	gamepad_is_connected()
		
	//	switch(self.deviceName){
	//		case "keyboard":{
	//			if( gamepad_is_connected(gamepadID) == true)
	//			break;
	//		}
	//	}
	//}
	
	
	////static bindings= bindings_struct;
	////static player=  []
	
	//repeat( player_count){
		
	//	var _bindingNames= variable_struct_get_names(bindings);
		
	//	for(var i= array_length(_bindingNames)-1;	i >= 0;	i-- ){
			
	//	}
		
	//	array_push(player, {
	//		input: "",
	//	});
	//}
	
	
	//var _inputTypes= variable_struct_get_names(bindings_struct);
	//for(var i= array_length(_inputTypes)-1;	i >= 0; i--){
	//	var _device= bindings_struct[i]
		
	//	bindings[$ _device]= {};
		
	//	var _bindings= variable_struct_get_names(_device);
	//	for(var b= array_length(_bindings)-1;	b >= 0;		b--){
	//		bindings[$ _inputTypes[i]][$ _bindings[b]]= {
				
	//		};
	//	}
	//}
	
	//// Generate bindings - keyboard
	////=============================
	//var _names= variable_struct_get_names(key_binds);
	//for(var i= array_length(_names)-1;	i >= 0; i--){
	//	keyboard[$ _names[i]].bindings= key_binds[$ _names[i]];
	//	keyboard[$ _names[i]].value= 0;
	//	keyboard[$ _names[i]].previous= 0;
	//}
	
	//// Generate bindings - gamepad
	////============================
	//var _names= variable_struct_get_names(gamepad_binds);
	//for(var i= array_length(_names)-1;	i >= 0; i--){
	//	gamepad[$ _names[i]].bindings= gamepad_binds[$ _names[i]];
	//	gamepad[$ _names[i]].value= 0;
	//	gamepad[$ _names[i]].previous= 0;
	//}
}