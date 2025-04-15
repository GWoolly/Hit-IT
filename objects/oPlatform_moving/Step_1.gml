/// @description Pre-calculate position
if(wp.active == true
&& wp.direction != 0){
    
    waypoint_instance_update(wp);
    
    // Update velocity
    //================
    velocity.x= x - xprevious;
    velocity.y= y - yprevious;
}
else{// Not moving
    velocity.x= 0;
    velocity.y= 0;
}
exit;






if( active == true){
    
    previous.index= index;
    index= floor(position);
    
    var _pointA= waypoints[index];
    var _pointB= waypoints[modulo(index + 1, array_length(waypoints) )];
    var _distance= point_distance(_pointA.x, _pointA.y, _pointB.x, _pointB.y);
    
    // Update position or wait
    //========================
    if(wait_timer >= 0){// Is waiting
        position= index;
        wait_timer-= DELTA_RATIO;
    }
    else if( index !=index_previous && _pointA.wait > 0){// Start waiting - Bug
        position= waypoints[index_previous];
        wait_timer= _pointA.wait;
    }
    else{// Update position
        position+= (_distance == 0)? 0 : move_direction * ((move_speed / _distance) * DELTA_RATIO * active);
    }
    
    
    // Check if at end of path
    if( waypoint_end_reached(waypoints, position, move_direction) == true){
        end_action_callback();
    }
}
