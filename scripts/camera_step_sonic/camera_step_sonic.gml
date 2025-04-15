function camera_step_sonic(){
    static debug_draw= function(){
        with(other){
            if(follow != noone){
                
                draw_rectangle(box.x1, box.y1, box.x2, box.y2, true);   //Trap / Deadzone
                draw_line(box.x1, box.ground, box.x2, box.ground);      //Ground plane
                draw_circle(follow.x, follow.y, 1, false);              //Follow's position within the trap
                
                //draw_line(box.x1 - lookDistX, box.y1, box.x1 - lookDistX, box.y2);
                //draw_line(box.x2 + lookDistX, box.y1, box.x2 + lookDistX, box.y2);
                
                draw_arrow(xprevious, yprevious, x, y, 1);              //Movement
                draw_crosshair(x + box.x, y + box.y, 6);//Trap center
                
                draw_set_color(c_blue);
                draw_crosshair(x, y, 4);//Camera center
                
                draw_set_color(c_white);
            }
        }
    }
    
    
    
    if (follow != noone) {
        static dampening = 0.2; 
        static lookSpeed = 0.1;
        static focusAmount = 0.0; // 0 = No focus, 1 = Fully focus on custom point
        static focusX = 0;
        static focusY = 0;

        var _px = follow.x;
        var _py = follow.y;

        // Update trap position
        if (follow.onGround) {
            box.ground = _py;
            box.y2 = box.ground + box.y; // Trap bottom
            box.y1 = box.y2 - box.h;     // Trap top
        }
        box.x1 = x - (box.w >> 1);
        box.x2 = x + (box.w >> 1);
        
        
        //Clamp camera to room
        static boundary={
            x1: width >> 1,
            x2: room_width - (width >> 1),
            
            y1: height >> 1,
            y2: room_height - (height >> 1),
        }
        //x= clamp(x, boundary.x1, boundary.x2)// Clamp camera to room
        //y= clamp(y, boundary.y1, boundary.y2)// Clamp camera to room
        
        
        
        
        //Adjust camera based on trap
        if(_px < box.x1){ // Moving left
            camX= _px + (box.w >> 1);
            //lookX= lerp(lookX, follow.velocity.x * 10, lookSpeed);
            lookX= lerp(lookX, -lookDistX, lookSpeed * DELTA_RATIO);
            
            lerpX=  (box.x1 - _px) / lookDistX
        }
        else if(_px > box.x2){// Moving right
            camX= _px - (box.w >> 1);
            //lookX= lerp(lookX, follow.velocity.x * 10, lookSpeed);
            lookX= lerp(lookX, lookDistX, lookSpeed * DELTA_RATIO);
            
            lerpX=  (_px - box.x2) / lookDistX;
        }
        else{
            //lookX= lerp(lookX, 0, lookSpeed);
        lookX= lerp(lookX, 0, lookSpeed * DELTA_RATIO * 1); 
            //lerpX=  ((_px- box.x1) - box.x2) / box.w;
            lerpX=  (_px - box.x1) / (box.x2 - box.x1);//Inverse lerp to get player position inside of trap
        } 
        

        // Unlock Y-axis if player moves out of vertical bounds
        if (_py < box.y1 || _py > box.y2) {
            camY = _py;
        }

        // Smooth camera position based on distance from trap
        var distanceFactor = abs(_px - camX) / box.w;
        var adjustedDampening = lerp(dampening, 0.25, distanceFactor);

        x = lerp(x, lerp(camX, focusX, focusAmount), adjustedDampening);
        y = lerp(y, lerp(camY, focusY, focusAmount), dampening);
        
        
        //Clamp camera to room
        static boundary={
            x1: width >> 1,
            x2: room_width - (width >> 1),
            
            y1: height >> 1,
            y2: room_height - (height >> 1),
        }
        x= clamp(x, boundary.x1, boundary.x2)// Clamp camera to room
        y= clamp(y, boundary.y1, boundary.y2)// Clamp camera to room
        
        
        // Apply final look-ahead offset
        var _camX = x + lookX;
        var _camY = y - 16; // Slight vertical offset for better framing
        camera_set_view_mat(camera, matrix_build_lookat(_camX, _camY, -10, _camX, _camY, 0, rotation.x, rotation.y, rotation.z));
    }

    
    
    
    
    exit;
    if(follow != noone){
        
        static dampening= 0.5;
        static lookSpeed= 0.1;
        
        static focusAmount= 0;
        static focusX=0;
        static focusY=0;
        
        static smoothVelocityX = 0;
        smoothVelocityX = lerp(smoothVelocityX, follow.velocity.x, 0.01 * DELTA_RATIO);


        var _px= follow.x;
        var _py= follow.y;
        
        
        // Update trap Y when on ground
        if( follow.onGround == true){
            box.ground= _py;// Set current ground position.
            
            //Bottom of trap is offset just below ground
            box.y2 = box.ground + box.y;//Trap bottom
            box.y1 = box.y2 - box.h;//Trap top
        }
        
        // Update trap X
        box.x1= x - (box.w >> 1);// Trap Left edge
        box.x2= x + (box.w >> 1);// Trap Right edge
        
        // Target position
        var camX= x;
        var camY= box.ground;
        
        
        lookDistX= 32
        
        static lerpX= 0;
        
        //Adjust camera based on trap
        if(_px < box.x1){ // Moving left
            camX= _px + (box.w >> 1);
            //lookX= lerp(lookX, follow.velocity.x * 10, lookSpeed);
            lookX= lerp(lookX, -lookDistX, lookSpeed * DELTA_RATIO);
            
            lerpX=  (box.x1 - _px) / lookDistX
        }
        else if(_px > box.x2){// Moving right
            camX= _px - (box.w >> 1);
            //lookX= lerp(lookX, follow.velocity.x * 10, lookSpeed);
            lookX= lerp(lookX, lookDistX, lookSpeed * DELTA_RATIO);
            
            lerpX=  (_px - box.x2) / lookDistX;
        }
        else{
            //lookX= lerp(lookX, 0, lookSpeed);
           lookX= lerp(lookX, 0, lookSpeed * DELTA_RATIO * 1); 
            //lerpX=  ((_px- box.x1) - box.x2) / box.w;
            lerpX=  (_px - box.x1) / (box.x2 - box.x1);//Inverse lerp to get player position inside of trap
        } 
        
           
        if(_py < box.y1 || _py > box.y2){// Unlock camera Y when trap is reached
            camY= _py;
        }
        
        // Smoothly lerp cam position

        //lookX= lerp(lookX, follow.velocity.x * 10, dampening);
        lookY= -16;
        
        var distanceFactor = abs(_px - camX) / box.w;
        var _vx= abs(follow.velocity.x);
        var _vy= abs(follow.velocity.y);
        //var adjustedDampening = clamp(dampening * (1 + distanceFactor), dampening, 0.5);
        //var adjustedDampeningX = clamp(dampening * (1 + _vx * 0.1), dampening, 0.3);
        var adjustedDampeningX = clamp(dampening * (1 + abs(smoothVelocityX) * 0.1), dampening, 0.3);
        var adjustedDampeningY = clamp(dampening * (1 + _vy * 0.1), dampening, 0.3);
       
        
        
        //x= lerp(x, lerp(camX, focusX, focusAmount), lerpX);
        x = lerp(x, lerp(camX, focusX, focusAmount), adjustedDampeningX);
        y= lerp(y, lerp(camY, focusY, focusAmount), adjustedDampeningY);// ChatGPT bug? Both a and b values are the same!
        
        var _camX= x + lookX;
        var _camY= y + lookY;
        camera_set_view_mat(camera, matrix_build_lookat(_camX,_camY,-10,	_camX,_camY,0,	rotation.x,rotation.y,rotation.z));
    }
}