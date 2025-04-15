function attached_update(){
	
	// Iterate through children
	for(var i= array_length(attach.children)-1;		i >= 0;		i--){
		
		var _child= attach.children[i];
		var _angle= rotation - rotation_previous;
		
		_child.direction+= _angle;
			
		//Move to new position
		_child.x+= x - xprevious;
		_child.y+= y - yprevious;
		
		/*
		_child.x= lengthdir_x(_child.distance, _child.direction);
		_child.y= lengthdir_y(_child.distance, _child.direction);
		*/
	}
	
	rotation_previous= rotation;
}