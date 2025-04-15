function camera_step_yolo(){
    static draw= function(){
        draw_rectangle(trap.x1, trap.y1, trap.x2, trap.y2, true);
    }
    static trap={
        width: 32,
        height: 32,
        x1: 0,
        x2: 0,
        y1: 0,
        y2: 0,
    }
    
    static lookX= 0;
    static lookSpeed= 0.1;
    static acChannel= animcurve_get_channel(acCamera, "cubic");
    static offset= 32;
    static dist= 0;
    static trapTimer = 0; // Timer to track time inside the trap
    
    if (follow != noone) {
        
        trap.x1 = x - (trap.width >> 1);
        trap.x2 = x + (trap.width >> 1);
    
        if (follow.onGround == true) {
            var _h = trap.height >> 1;
            trap.y2 = follow.y + 8;
            trap.y1 = trap.y2 - trap.height;
        }
    
        var _cam = follow.x;
        var _distPrevious = dist;
        var _maxSpeed= 4
        if (follow.x < trap.x1 && follow.velocity.x < 0) { // Moving left
            //var _l = clamp(abs(follow.velocity.x) / _maxSpeed, 0, 1);
            _l = ((follow.x - trap.x1) / trap.width) * 2 - 1;
            
            var _acE = animcurve_channel_evaluate(acChannel, _l);
            dist = lerp(dist, -lerp(dist, offset, _acE), 0.1);
            trapTimer = 0; // Reset timer when moving
        } 
        else if (follow.x > trap.x2 && follow.velocity.x > 0) { // Moving right
            //var _l = clamp(abs(follow.velocity.x) / _maxSpeed, 0, 1);
            _l = ((follow.x - trap.x1) / trap.width) * 2 - 1;
            
            var _acE = animcurve_channel_evaluate(acChannel, _l);
            dist = lerp(dist, lerp(dist, offset, _acE), 0.1);
            trapTimer = 0; // Reset timer when moving
        } 
        else { 
            _cam= x;
            trapTimer += delta_time; // Start counting once inside trap
            dist = lerp(dist, 0, 0.5); // Smoothly reset camera offset
            //if (trapTimer > 2000) { // If inside for more than 2 seconds
                //dist = lerp(dist, 0, 0.05); // Smoothly reset camera offset
            //}else{
                //_cam= x;
            //}
        }
    
        x = lerp(x, _cam, 0.1);
        y = lerp(y, follow.y - 24, 0.1);
    
        _cam += dist;
        camera_set_view_mat(camera, matrix_build_lookat(_cam, y, z, _cam, y, 0, rotation.x, rotation.y, rotation.z));
    }
    
    
    
    exit;// My code
    static trap={
        width: 32,
        height: 32,
        x1: 0,
        x2: 0,
        y1: 0,
        y2: 0,
    }
    
    static lookX= 0;
    static lookSpeed= 0.1;
    
    static acChannel= animcurve_get_channel(acCamera, "cubic");
    
    static offset= 32;
    static dist= 0;
    
    //Begin camera stuff
    if( follow != noone){
        
        trap.x1= x - (trap.width >> 1);
        trap.x2= x + (trap.width >> 1);
        
        // Update the trap Y when on ground
        if(follow.onGround == true){
            var _h= trap.height >> 1;
            trap.y2= follow.y + 8;
            trap.y1= trap.y2 - trap.height;
        }
        
        var _cam= follow.x;
        var _distPrevious= dist;
        if(follow.x < trap.x1 && follow.velocity.x < 0){//Moving left
            var _l= abs(follow.x + follow.velocity.x) / trap.x1;
            var _l= abs(follow.velocity.x) / 4;
            var _acE= animcurve_channel_evaluate(acChannel, abs(max( _l) ))
            dist= min(dist, -lerp(0, offset, _acE) );
            //_cam+= -_dist;
        }
        else if(follow.x > trap.x2 && follow.velocity.x > 0){// Moving right
            var _l= abs(follow.x + follow.velocity.x) / trap.x2;
            var _l= abs(follow.velocity.x) / 4;
            var _acE= animcurve_channel_evaluate(acChannel, abs(max( _l) ))
            dist= max(dist, lerp(0, offset, _acE) );
            //_cam+= _dist;
            if(dist > 16){
                var _test=true;
            }
        }
        else{
            var _test= dist;
            dist= lerp(dist, 0, 0.1);
            var _cam= x;
            //var _cam= lerp(x+_distPrevious, x+dist, 0.001);
        }
        
        
        //var _offset= 32;
        //var _dist= (follow.x - (trap.x1 + (trap.width >> 1))) / trap.width;
        //var _x= sign(_dist) * lerp(0, _offset, animcurve_channel_evaluate(acChannel, abs(max(0, _dist) )));
        //var _dir= (follow.velocity.x >= 0)? 1 : -1;
        x= lerp(x, _cam, 0.1);
        y= lerp(y, follow.y - 24, 0.1);
        
        _cam+= dist;
        camera_set_view_mat(camera, matrix_build_lookat(_cam,y,z,	_cam,y,0,	rotation.x,rotation.y,rotation.z));
    }
}