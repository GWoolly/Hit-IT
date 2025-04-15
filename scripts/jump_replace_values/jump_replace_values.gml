function jump_replace_values(_jumpStruct, _newStruct){
	_jumpStruct.height= _newStruct.height;
	_jumpStruct.duration= _newStruct.duration;
	
	_jumpStruct.apexHeight= _newStruct.apexHeight;
	_jumpStruct.apexGravity= _newStruct.apexGravity;
	
	_jumpStruct.bufferMax= _newStruct.bufferMax;
	_jumpStruct.coyoteMax= _newStruct.coyoteMax;
	
	// Calculate velocities
	_jumpStruct.speed= jump_get_speed(_newStruct.height, _newStruct.duration);
	_jumpStruct.gravity= jump_get_gravity(_newStruct.height, _newStruct.duration);
}