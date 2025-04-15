//gml_pragma("forceinline", "jump_step()")
function jump_step(/*jump, velocity,*/ inputPressed, jumpAngle=90){
	
	
	// Jump Buffer
	//============
	jump.buffer= (inputPressed == true)?	jump.bufferMax	:	max(-1, jump.buffer - (1 * DELTA_RATIO));
	
	// Coyote Time
	//============
	if(onGround == true){
		jump.coyote= jump.coyoteMax;
		//jump.velocity= 0;
	}
	else{
		jump.coyote= max(-1, jump.coyote - (1 * DELTA_RATIO));
	}
	
	
	// Jump Apex and Gravity
	//======================
	if( abs(velocity) <= jump.apexSpeed){// At the apex
		/*
		velocity+= jump.apexGravity;
		/*/
		velocity.x+= dcos(jumpAngle) * (jump.apexGravity * DELTA_RATIO);
		velocity.y+= dsin(jumpAngle) * (jump.apexGravity * DELTA_RATIO);
		//*/
	}
	else{
		/*
		velocity+= jump.gravity;
		/*/
		velocity.x+= dcos(jumpAngle) * (jump.gravity * DELTA_RATIO);
		velocity.y+= dsin(jumpAngle) * (jump.gravity * DELTA_RATIO);
		//*/
	}
	
	
	// Perform jump
	//=============
	if( jump.buffer >= 0 && jump.coyote >= 0){// Input receieved for jump and can jump	
		
		// Calculate new velocity from jump
		//=================================
		switch(jumpAngle){
			case 90://Up
				velocity.y= jump.speed;
				break;
			case 180://Down
				velocity.y= -jump.speed;
				break;
			
			case 0://Right
				velocity.x= jump.speed;
				break;
			case 270://Left
				velocity.x= -jump.speed;
				break;
			
			default:
				// Keep momentum of both axies when jumping from an angled surface.
				velocity.x= (dsin(jumpAngle) * velocity.x) + (dcos(jumpAngle) * jump.speed);
				velocity.y= (dcos(jumpAngle) * velocity.y) + (dsin(jumpAngle) * jump.speed);	
				break;
		}
		
		//Update jump checker vars so we can't initiate another jump
		//==========================================================
		jump.coyote= -1;
		jump.buffer= -1;
		onGround= false;
		
		return true;// Jump started
	}
	
    onGround= false;// Stops infinite jumps
	
	return false;// Not jumping
}