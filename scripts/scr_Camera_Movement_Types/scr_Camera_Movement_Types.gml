/// @desc  Function Description
/// @param {real} width  Deadzone's width.
/// @param {real} height  Deadzone's height.
// distanceX was here
/// @param {real} [border_offset_x]=0  The x offset of the camera's border.
/// @param {real} [border_offset_y]=0  The y offset of the camera's border. Value of zero will set the bottom of the border to be equal to follow.bbox_bottom.
function camera_state_followFocus(width, height, border_offset_x=0, border_offset_y= 0, smoothing=0.1) constructor {
    
    static draw= function(){
        // Right region
        var _scale= 1.0
        draw_sprite_ext(sprDebugCameraTrap, 0, border.right,           border.top, 1.0, border.height * 0.1, 0.0, c_white, 1.0);
        draw_sprite_ext(sprDebugCameraTrap, 0, border.left + border.width,           border.top, 1.0, border.height * 0.1, 0.0, c_white, 1.0);
        
        // Left region                          
        draw_sprite_ext(sprDebugCameraTrap, 0, border.left,           border.top, -1.0, border.height * 0.1, 0.0, c_white, 1.0);
        draw_sprite_ext(sprDebugCameraTrap, 1, border.right - border.width,  border.top, -1.0, border.height * 0.1, 0.0, c_white, 1.0);
        
        //Ground
        draw_sprite_ext(sprDebugCameraTrap_floor, 0, border.left + (border.width >> 1), groundPositionY, border.width * 0.2, 1.0, 0.0, c_white, 1.0);
        
        
        draw_crosshair(other.x, other.y, 4);// Camera center
        
        draw_set_color(c_blue);
        draw_rectangle(border.left, border.top, border.right, border.bottom, true);
        draw_arrow(other.x, other.y, border.left, border.top, 1);
        //draw_circle(mySide? trap.right : trap.left, other.y, 3, false);
        draw_set_color(c_white);
        
        //draw_rectangle(, trap.y1, trap.x2, trap.y2, true);
    }
    
    //
    //offset= {
        //x: offset_x,
        //y: offset_y,
    //}
    //
    //trap={
        //"width": width,
        //"height": height,
        //
        //x: 0,
        //y: trap_ground_offset,
        //
        //ground: 0,
        //
        //left: 0,
        //leftB: 0,
        //
        //right: 0,
        //rightB: 0,
        //
        //y1: 0,
        //y2: 0,
    //}
    //
//
    //
    //self.smoothing= 0.9;    // Smooths camera movement
    //
    //self.look_x= look_x;
    
    
    
    //speed= {
        //acceleration: 0.1,
        //friction: 0.1,
        //"max":  8,
    //};
    
    
    
    focus={// The forward focus system
        
        //Look ahead
        distanceX: 0,  // How far away from the camera's center point to look
        currentX: 0,        // The current position
        targetX: 0,         // The target offset
        
        //Movement
        speed: 0.1,
        friction: 0.1,
        
        //// Zoning
        //deadzone: 8,        // The distance in the opposite direction that the instance has to move before switching to the opposite direction.
        //left: x + look_x,   // When moving left, the border is larger than x to look further left of the instance.
        //right: x - look_x,  // When moving right, the border is smaller than x to look further right of the instance.
    };
    
    
    var _halfWidth= width >> 1;
    var _halfHeight= height >> 1;
    border={
        "width": width,     // The width of the deadzone
        "height": height,
        
        offset: new vec2(border_offset_x, border_offset_y),
        //deadzoneSize: 8,
        
        //The actual border                 
        left:   other.x - _halfWidth + border_offset_x,     // When moving left, the border is larger than x to look further left of the instance.
        right:  other.x + _halfWidth + border_offset_x,    // When moving right, the border is smaller than x to look further right of the instance.
        top:    other.y - _halfHeight + border_offset_y,
        bottom: other.y + _halfHeight + border_offset_y,
        
    };
    
    x= ptr(other.x);
    y= ptr(other.y);
    
    groundPositionY= 0;// The ground position that the follower's bbox_bottom is colliding
    self.smoothing= smoothing;// Lerp smoothing amount
    
    
    step= method(other, function(){
        //Reference variables from the struct
        var focus= other.focus;
        var border= other.border;
        var smoothing= other.smoothing;
        
        
        //with(self) {//The camera instance
            if( follow != noone){
                //var groundPositionY= other.groundPositionY;
                var _smoothing= 0.9;
                
                //Update focus zone positions
                var _borderWidthHalf= border.width >> 1;
                border.left= x - _borderWidthHalf + border.offset.x;
                border.right= x + _borderWidthHalf + border.offset.x;
                
                //border.bottom= y + border.offset.y;
                border.bottom= y + other.groundPositionY;
                border.top= border.bottom - border.height;
                
                //Swap look ahead direction when moving beyond the deadzone
                if( follow.x <= border.right - border.width && follow.velocity.x < 0){//Activate focus left 
                    
                    //focus.targetX= -focus.distanceX;
                }
                else if( follow.x >= border.left + border.width && follow.velocity.x > 0){//Activate focus right
                    
                    //focus.targetX= focus.distanceX;
                }
                else{//Recenter look ahead after X seconds
                    
                }
                
                focus.currentX= approach(focus.currentX, focus.targetX, focus.speed);// Transition the look ahead position to be in the correct direction of travel.
                
                
                // Set the ground position
                if(follow.onGround == true){
                    other.groundPositionY= follow.bbox_bottom;
                    //velocity.y+= approach(0, follow.bbox_bottom - y, velocity.value.accel)// Increase velocity to move to the follow point
                }
                else{// In air
                    //if(follow.y < border.top && follow.velocity.y < 0){// Move upwards
                        ////velocity.y+= -speed.acceleration;
                        //
                        //velocity.y+= approach(0, y - follow.bbox_bottom, velocity.value.accel)
                    //}
                    //else if(follow.y > border.bottom && follow.velocity.y > 0){// Move downwards
                        ////velocity.y+= speed.acceleration;
                        //velocity.y+= approach(0, follow.bbox_bottom - y, velocity.value.accel)
                    //}
                    //else{
                        //velocity.y= approach(velocity.y, 0, velocity.value.fric);
                    //}
                }
                
                
                //Update X velocity
                if(follow.bbox_left <= border.left || follow.bbox_right >= border.right){
                    var _xDist= follow.x - (x + border.offset.x); 
                    velocity.x= _xDist * smoothing;
                }
                else{
                    velocity.x*= velocity.value.fric;
                }
                
                //Update Y velocity
                if( follow.bbox_bottom > border.bottom || follow.bbox_top < border.top || follow.onGround == true){
                    var _yDist= other.groundPositionY - (y + border.offset.y); 
                    velocity.y= _yDist * smoothing;
                }
                else{
                    velocity.y*= velocity.value.fric;
                }
                
                
                //// Update camera velocity
                //if( follow.x <= border.left){//Move left 
                    //velocity.x+= -velocity.value.accel;
                //}
                //else if(follow.x >= border.right){//Move right
                    //velocity.x+= velocity.value.accel;
                //}
                //
                //
                //if(abs(follow.velocity.x) < 0.1){
                    //velocity.x*= velocity.value.fric;
                //}
                
                

                //velocity.x= clamp(velocity.x, -speed.max, speed.max)
                //x= lerp(x, x + focus.currentX + velocity.x, smoothing);
            }
        //}
    });
    
    
    //*/
    // Perform end-step
    static stepOLD = function() {
        static aheadCurrentX = 0;
        static aheadTargetX = 0;
        static velocityX = 0;
    
        static speedAccelerate = 0.75;
        static speedDampening = 0.9; // Reduced for smoother slow-down
        static speedMax = 4.0; // Limit max camera speed
    
        with (other) {
            if (follow != noone) {
                var trap = other.trap;
                var look_x = other.look_x;
                var offset = other.offset;
                
                var focus = other.focus;// in use with new
    
                // Set up trap boundary offsets
                var _trapOffsetX = x + trap.x;
                var _trapW = look_x >> 1; // Half look range
                var _trapBoarder = 8; // Buffer size
    
                trap.ground = (follow.onGround) ? follow.bbox_bottom : trap.ground;
                
                trap.left = _trapOffsetX + _trapW;
                trap.right = _trapOffsetX - _trapW;
                trap.leftB = trap.right - _trapBoarder;
                trap.rightB = trap.left + _trapBoarder;
                
                trap.y2 = trap.ground + trap.y;
                trap.y1 = trap.y2 - trap.height;
    
                // Camera movement settings
                var _swapLookSpeed = 0.2; // Smooth transition speed
                
                // Ensure the camera restricts movement beyond trap edges
                if (follow.x >= trap.rightB && follow.velocity.x > 0) {
                    // If moving right past trap, camera moves to keep follow at trap.right
                    aheadTargetX = 1;
                    other.mySide = 1;
                } 
                else if (follow.x <= trap.leftB && follow.velocity.x < 0) {
                    // If moving left past trap, camera moves to keep follow at trap.left
                    aheadTargetX = -1;
                    other.mySide = 0;
                }
    
                // Ensure player cannot move past trap's edges
                var _targetSpeedX= 0;
                static _cameraSpeed= 1;
                var _SpeedX= 0.6;
                var _inv= 0;
                if (follow.x > trap.right && aheadTargetX == 1) {
                    //follow.x = trap.right;
                    //follow.velocity.x = min(0, follow.velocity.x); // Stop movement
                    _targetSpeedX= follow.velocity.x;
                    var _inv= lerp_inverse(trap.right, x, follow.x) + 1;
                    velocityX = lerp(velocityX, _cameraSpeed, _inv);
                } 
                else if (follow.x < trap.left && aheadTargetX == -1) {
                    //follow.x = trap.left;
                    //follow.velocity.x = max(0, follow.velocity.x); // Stop movement
                    var _inv= lerp_inverse(trap.left, x, follow.x) + 0;
                    _targetSpeedX= follow.velocity.x;
                    velocityX = lerp(velocityX, -_cameraSpeed, _inv);
                    
                }
                else{
                    velocityX = lerp(velocityX, 0, 0.1);
                }
                
                // Smoothly transition the camera
                aheadCurrentX = lerp(aheadCurrentX, aheadTargetX * look_x, _swapLookSpeed);
    
                // Apply velocity to camera movement
                //velocityX = lerp(velocityX, _targetSpeedX, speedAccelerate);
                velocityX = clamp(velocityX, -speedMax, speedMax);
                x += velocityX;
    
                // Smooth Y movement to avoid sudden snapping
                y = lerp(y, trap.ground, 0.2);
                
            }
        }
    };
    
    
    /*/
    static step = function() {
        static aheadCurrentX = 0;
        static focusX = other.x; // Default camera focus
        static aheadTargetX = 0;
        static vx = 0; // Camera velocity X
        static vy = 0; // Camera velocity Y
    
        with(other) {
            if (follow != noone) {
                var trap = other.trap;
                var look_x = other.look_x;
                var offset = other.offset;
    
                trap.ground = (follow.onGround) ? follow.bbox_bottom : trap.ground;
    
                trap.x1 = x + trap.x - (trap.width >> 1);
                trap.x2 = x + trap.x + (trap.width >> 1);
                trap.y2 = trap.ground + trap.y;
                trap.y1 = trap.y2 - trap.height;
    
                var trapCenter = (trap.x1 + trap.x2) * 0.5;
                var playerOffset = follow.x - trapCenter; // Distance from center
    
                // Pull-rope properties
                var _ropeMaxLength = 100;  // Max distance before camera stops keeping up
                var _ropePullForce = 0.05;  // How strongly the camera tries to catch up
                var _ropeSlack = 5;       // Small slack range to reduce jitter
                var _ropeDamping = 0.5;    // Dampens oscillations (lower = more damping)
                
                // Calculate distance between player and camera
                var dx = follow.x - x;
                var dy = follow.y - y;
                var distance = sqrt(dx * dx + dy * dy);
    
                // Check if the rope is stretched beyond its max length
                if (distance > _ropeMaxLength) {
                    // Normalize direction
                    var angle = arctan2(dy, dx);
                    var targetX = follow.x - cos(angle) * _ropeMaxLength;
                    var targetY = follow.y - sin(angle) * _ropeMaxLength;
    
                    // Apply pull force
                    vx += (targetX - x) * _ropePullForce;
                    vy += (targetY - y) * _ropePullForce;
                } 
                else if (distance > _ropeSlack) {
                    // Camera moves smoothly towards the player if within slack range
                    vx += dx * _ropePullForce;
                    vy += dy * _ropePullForce;
                }
    
                // Apply damping to prevent excessive bouncing
                vx *= _ropeDamping;
                vy *= _ropeDamping;
    
                // Move camera
                x += vx;
                y += vy;
    
                // Update camera matrix
                var _ox = x + offset.x + aheadCurrentX;
                var _oy = y + offset.y;
                camera_set_view_mat(camera, matrix_build_lookat(_ox, _oy, z, _ox, _oy, 0, rotation.x, rotation.y, rotation.z));
            }
        }
    };
    
    
    //*/
}