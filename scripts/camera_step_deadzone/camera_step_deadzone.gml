function camera_step_deadzone(){

    if(follow != noone){
        
        //Define deadzone boundaries
        deadzone.cx= x + deadzone.x;
        deadzone.cy= follow.groundY;
        
        deadzone.x1= deadzone.cx - (deadzone.width >> 1);
        deadzone.x2= deadzone.cx + (deadzone.width >> 1);
        deadzone.y1= deadzone.cy - (deadzone.height >> 1);
        deadzone.y2= deadzone.cy + (deadzone.height >> 1);
        
        // Instance position relative to deadzone centre
        var _dx= follow.x - deadzone.cx;
        var _dy= follow.y - deadzone.cy;
        
        var _push={
            x: 0,
            y: 0
        }
        
        
        if(follow.x < deadzone.cx){//Left side
            _push.x= -abs(_dx / (deadzone.width >> 1));
        }
        else if(follow.x > deadzone.cx){// Right side
            _push.x= abs(_dx / (deadzone.width >> 1));
        }
        
        if(follow.y < deadzone.cy){//Top side 
            _push.y= -abs(_dy / (deadzone.height >> 1))
        }
        else if(follow.y > deadzone.cy){
            _push.y= abs(_dy / (deadzone.height >> 1))
        }
        
        
        // Smoothly move camera with quadrant influence
        target_x= follow.x + offset.x + (_push.x * lead_factor.x);
        target_y= follow.y + offset.y + (_push.y * lead_factor.y);
        
        //Lerp camera to the target position
        x= lerp(x, target_x, smoothing);
        y= lerp(y, target_y, smoothing);
        
        
    }
}