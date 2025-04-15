function jump_create_system(_jumpValuesStruct= undefined) constructor{
	
	if(_jumpValuesStruct == undefined){
		height= 0;		// Height in pixels
		duration= 0;	// How long jump lasts
		
		apexHeight= 0;	// Percentage of speed
		apexGravity= 0;	// Percentage gravity
		
		
		bufferMax= 0;
		coyoteMax= 0;
	}
	else{
		height= _jumpValuesStruct.height?? 0;		// Height in pixels
		duration= _jumpValuesStruct.duration?? 0;	// How long jump lasts
		
		apexHeight= _jumpValuesStruct.apexHeight?? 0;	// Percentage of speed
		apexGravity= _jumpValuesStruct.apexGravity?? 0;	// Percentage gravity
		
		
		bufferMax= _jumpValuesStruct.bufferMax;
		coyoteMax= _jumpValuesStruct.coyoteMax;
	}
	
	
	// Non-editable
	speed= jump_get_speed(height, duration);
	gravity= jump_get_gravity(height, duration);
	
	onGround= true;
	time= 0;		
	
	buffer= 0;
	coyote= 0;
	
	
	//
	set= function(_jumpValuesStruct){
		height= _jumpValuesStruct.height;		// Height in pixels
		duration= _jumpValuesStruct.duration;	// How long jump lasts
		
		apexHeight= _jumpValuesStruct.apexHeight;	// Percentage of speed
		apexGravity= _jumpValuesStruct.apexGravity;	// Percentage gravity
		
		
		bufferMax= _jumpValuesStruct.bufferMax;
		coyoteMax= _jumpValuesStruct.coyoteMax;
		
		speed= jump_get_speed(self.height, self.duration);
		gravity= jump_get_gravity(self.height, self.duration);
		apexSpeed= jump_get_speed(self.height, self.duration)
	}
	
	refresh= function(){
		speed= jump_get_speed(self.height, self.duration);
		gravity= jump_get_gravity(self.height, self.duration);
	}
	
	
	update= function(_inputState){
	}
}