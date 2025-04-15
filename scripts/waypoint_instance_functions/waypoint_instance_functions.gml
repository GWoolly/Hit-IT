/// @desc  Initialises the instance's waypoint struct system.
/// 
/// @param {array} waypoints            Array of waypoints.
/// @param {real} position              Starting position.
/// @param {any} [end_action]="stop"    String "stop", "reverse", "loop", or custom callback method.
/// @param {real} [speed]=0  0  0  0	Speed to move through the waypoints array.
/// @param {real} [direction]=1         Signed movement direction.
/// @param {bool} [active]=true         Whether the instance should start moving towards the waypoints.
function waypoint_instance_create(waypoints, position, end_action="stop", speed=0, direction=1, active= true) constructor{
    
    var _past_room_creation_code= waypoint_array_set(self, waypoints);
    
    if( _past_room_creation_code == true){// Can continue constructing waypoint system.
        
        self.active= active;
        self.speed= abs(speed);
        self.direction= sign(direction);
        
        waypoint_set_position(self, position);
        waypoint_set_end_action(self, end_action);
        
        index= floor(position);
        index_previous= -1;
        
        //Wait timer
        if(position mod 1 == 0){
            wait_timer= self.waypoints[position].wait;
        }
        else{
            wait_timer= -1;
        }	
    }
}





/// @desc	Updates the position of the given waypoint instance if active.
///
/// @param {any*} waypoint_struct	Waypoint instance struct.
function waypoint_instance_update(waypoint_struct){
    with(waypoint_struct){
        
        index_previous= index;
        index= (direction >= 0)? floor(position) : ceil(position);
        
        var _index= floor(position);
        
        var _pointA= waypoints[_index];
        var _pointB= waypoints[modulo(_index + 1, array_length(waypoints) )];
        var _distance= point_distance(_pointA.x, _pointA.y, _pointB.x, _pointB.y);
        
        // Update position
        //================
        if(wait_timer >= 0){// Is waiting
            position= index;
            wait_timer-= DELTA_RATIO;
        }
        else if( index != index_previous){// Changed waypoint target
            
            waypoints[index].callback();// Perform custom callback
            
            if(_pointA.wait > 0){
                position= waypoints[index];
                wait_timer= _pointA.wait;
            }
            else{// Update position
                position+= (_distance == 0)? 0 : direction * ((speed / _distance) * DELTA_RATIO * active);
            }
        }
        else{// Update position
            position+= (_distance == 0)? 0 : direction * ((speed / _distance) * DELTA_RATIO * active);
        }
        
        
        // Perform end action
        //===================
        if( waypoint_end_reached(self) == true){
            end_callback();
        }
        
        // Move to new position
        //=====================
        waypoint_set_position(self, position);
    }
}



function waypoint_set_position(waypoint_struct, position){
    var _owner= other;
    
    with(waypoint_struct){
        self.position = modulo(position, array_length(waypoints) );
        
        var _pointA= floor(self.position);
        var _pointB= modulo(_pointA + 1, array_length(waypoints) );
        
        var _current= waypoints[_pointA];
        var _next= waypoints[_pointB];
        
        // Move to new position
        //=====================
        var _acPosition= animcurve_channel_evaluate( _next.channel, self.position mod 1);
        
        _owner.x= lerp(_current.x, _next.x, _acPosition);
        _owner.y= lerp(_current.y, _next.y, _acPosition);
    }
    
    return self.position;
}





/// @desc	Creates and assigns an array of waypoints to the waypoint struct.
///
/// @param {any*} waypoint_struct	Waypoint instance struct.
/// @param {array} array			An array of waypoint structs, self, or instance UUIDs from the room editor.
function waypoint_array_set(waypoint_struct, array=waypoint_struct.waypoints){
    
    for(var i= array_length(array)-1;	i >= 0;		i--){
        
        if( variable_struct_exists(array[i], "id") == true){// Parse instance
            if(variable_struct_exists(array[i], "callback") == true){
                array[i]= new waypoint_create(array[i].x, array[i].y, array[i].wait, array[i].curve, array[i].channel, array[i].callback);
            }
            else{
                waypoint_struct.waypoints= array;
                return false;
            }
        }
    }
    
    waypoint_struct.waypoints= array;
    return array_length(array) > 0;// Array isn't empty
}





function waypoint_set_end_action(waypoint_struct, callback){
    static stop= function(){
        position= clamp(position, 0, array_length(waypoints)-1);
        active= false;//Bug
    };
    
    
    static reverse= function(){
        direction*= -1;
            
        // Get the current position
        var _remainder= position - clamp(position, 0, array_length(waypoints)-1);
        if(position > 0){
            position= (array_length(waypoints)-1) - _remainder;
        }
        else{
            position= abs(_remainder);
        }
    };
    
    
    static loop= function(){
        position= modulo(position, array_length(waypoints));
    };
    
    
    // Set the end action when the platform reaches the end of its path
    //=================================================================
    switch(callback){
        case "reverse":
            waypoint_struct.end_action= "reverse";
            waypoint_struct.end_callback= method(other.id, reverse);
            break;
        case "loop":
            waypoint_struct.end_action= "loop";
            waypoint_struct.end_callback= method(other.id, loop);
            break;
        case "stop":
            waypoint_struct.end_action= "stop";
            waypoint_struct.end_callback= method(other.id, stop);
            break;
        
        default://Stop
            waypoint_struct.end_action= "custom";
            waypoint_struct.end_callback= callback;
    }
}





/// @desc Returns true if the end of the waypoints array has been reached.
///
/// @param {array} waypoints	Array of waypoints
/// @param {real} position		The current position in the waypoints array.
/// @param {real} move_speed	Current movement speed.
///
/// @returns {bool} Returns true if end of waypoints array has been reached.
function waypoint_end_reached(waypoint_struct){
    //var _move_direction= sign(move_speed);
    
    return( (waypoint_struct.position <= 0 && waypoint_struct.direction == -1)
    || (waypoint_struct.position >= array_length(waypoint_struct.waypoints)-1 && waypoint_struct.direction == 1)
    );
}



/**
 * Returns whether a waypoint struct exists, or has been fully initialised.
 * @param {struct} waypoint_struct  The waypoint struct to check.
 * @returns {bool}                  True if the waypoint struct exists and has been initialised.
 */
function waypoint_instance_exists(waypoint_struct){
    return variable_struct_exists(waypoint_struct, "active");
}


