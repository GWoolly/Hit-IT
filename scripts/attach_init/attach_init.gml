function attach_init(){
	attach={
		//Parent info
		parent: noone,
		index:	noone,
		distance: 0,	// Distance from parent's coordinates
		direction: 0,	// Percieved angle from parent. Please don't create a bone system from this!
		
		// My children
		children: [],
	}
	
	rotation= image_angle;
	rotation_previous=  rotation;
}