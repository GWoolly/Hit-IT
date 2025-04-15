function input_default_bindings() constructor{
	keyboard={
		//Directional
		left: ord("A"),
		right: ord("D"),
		up: ord("W"),
		down: ord("D"),
		
		// Actions
		jump: [vk_space, ord("J")],
		attack: ord("K"),
		
		// Other
		pause: ord("P"),
	};
	
	gamepad={
        deadzone: 0.1,
    
		//Directional
		left: gp_padl,
		right: gp_padr,
		up: gp_padu,
		down: gp_padd,
		
		// Sticks
		x: gp_axislh,
		y: gp_axislv,
		
		// Actions
		jump: gp_faced,
		attack: gp_facel,
		
		//Other
		pause: gp_start,
	};
}