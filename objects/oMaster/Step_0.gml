/// @description 

//Debug room restart
if(keyboard_check_pressed(ord("R"))){
			room_restart();
}


//Debug do key action
if(keyboard_check_pressed(vk_anykey)==true){
	show_debug_message($"Debug:: keyboard_key= {keyboard_key}")
	
	switch(keyboard_key){
		case vk_f12:{
			break;
		}
		
		default:{
		}
	}
}
		
		