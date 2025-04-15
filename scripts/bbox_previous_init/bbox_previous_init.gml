function bbox_previous_init(){
	if( variable_instance_exists(self.id, "previous") == false){
		self.previous= {};
	}
	
	bbox_previous_update();
}