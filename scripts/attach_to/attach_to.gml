function attach_to(parent, child= self.id){
	
	// Detach from parent
	if(child.attach.parent != noone){
		//detach_from();
		
		// Remove from parent object
		array_delete(attach.parent.attach.children, other.attach.index, 1);
		
		// Update self
		attach.parent= noone;
		attach.index= noone;
	}
	
	// Attach the object to another
	if(parent != noone){
		
		array_push(parent.attach.children, child);// Add child to parent
		
		// Add parent to child
		child.attach.index= array_length(parent.attach.children);
		child.attach.parent= parent;
		
		// Offset
		child.attach.distance= point_distance(parent.x, parent.y, child.x, child.y);
		child.attach.direction= point_direction(parent.x, parent.y, child.x, child.y);
	}
	else{
		child.attach.index= noone;
		child.attach.parent= noone;
	}
}