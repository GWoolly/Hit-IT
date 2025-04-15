/// @description 
event_inherited();

collideWithArray= [oPlayer];

// Catch-all when moving too fast!
bbox_previous_init();


wp= new waypoint_instance_create(waypoints, position, end_action, move_speed, move_direction);

//Collision Callback system
//=========================
dsCollisions= ds_list_create();//Stores all colliders within a step
ds_list_clear(dsCollisions);//Ensure that the list stars empty



////Get waypoints
////=============
//if(is_array(waypoints) == false){//Use elevator path
    
//}
//else{
//	array_insert(waypoints, 0, {x: x, y:y, "curve": curve});
//	position= 0;
//}

