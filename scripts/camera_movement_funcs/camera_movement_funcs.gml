/// @desc  Sets the velocity of the camera to move towards the follower instance is outside of the trap.
/// @param {struct} trap_struct  Description
/// @param {any*} follow_instance  Description
/// @param {struct} [smoothing]=0.1  Description
/// @param {any*} [bounds_struct] Description
function camera_move_trap_platformer(trap_struct, follow_instance, smoothing= 0.1, bounds_struct= undefined){
    static debug_draw= function(trap_struct, follow_instance= other.follow){
        if(follow_instance == noone){exit;}
        
        draw_rectangle(trap_struct.left, trap_struct.top, trap_struct.right, trap_struct.bottom, true);// Trap bounds
        draw_crosshair(other.x + trap_struct.x, other.y + trap_struct.y, 3);// Trap centre point
        draw_line(trap_struct.left, trap_struct.ground, trap_struct.right, trap_struct.ground)// Trap ground
        
        
        draw_crosshair(other.x, other.y, 4);//Camera's centre
    }
    
    
    if( follow != noone){
        
        
        var _targetY= follow_instance.y;
        // Check if instance is on the ground
        if( follow_instance.onGround == true){
            trap_struct.ground= follow_instance.bbox_bottom;
            _targetY= trap_struct.ground;
        }
        
        
        //Update trap
        var _halfWidth= trap_struct.width >> 1;
        var _halfHeight= trap_struct.height >> 1;
        
        trap_struct.left= x - _halfWidth + trap_struct.x;
        trap_struct.right= trap_struct.left + trap_struct.width;
        
        trap_struct.bottom= y + trap_struct.y;
        trap_struct.top= trap_struct.bottom - trap_struct.height;
        
        

        
        //Update Velocity X
        if(follow_instance.bbox_left <= trap_struct.left || follow_instance.bbox_right >= trap_struct.right){
            var _distX= follow_instance.x - (x + trap_struct.x);
            velocity.x= _distX * smoothing;
        }
        else{
            velocity.x*= smoothing;
        }
        
        
        //Update Velocity Y
        if(follow_instance.bbox_top <= trap_struct.top || follow_instance.bbox_bottom >= trap_struct.bottom || trap_struct.ground == noone){
            var _distY= follow_instance.y - y;
            velocity.y= _distY * smoothing;
            
            trap_struct.ground = noone;// Disable snap to ground
        }
        else if(follow_instance.onGround == true){
            var _distY= trap_struct.ground - y; 
            velocity.y= _distY * smoothing;
        }
        else{
            velocity.y*= smoothing;
            //var _distY= _targetY - y;
            //velocity.y= _distY * smoothing;
        }
    }
}