/// @description Create waypoint system
if(waypoint_instance_exists(wp) == false){
    wp= new waypoint_instance_create(waypoints, position, end_action, move_speed, move_direction);
}
