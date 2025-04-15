function state_machine_default_events() constructor{
	name= "noop"
	
	// State change handlers
	enter= function(){};
	leave= function(){};
	
	// Gamemaker events
	step= function(){};
	draw= function(){
		draw_self();
	};
}