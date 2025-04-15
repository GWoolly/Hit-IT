/// @description 
input.update_device();

var onGround_previous= onGround;

fsm.event.step();

y= min(y, 322)//Debug


//Debug
if(input.check_button_pressed("reset")== true){
    x= xstart;
    y= ystart;
    velocity= new vec2();
}

//Test juice
if(onGround == true && onGround_previous == false){
    
    var _impactForce= abs(velocity_previous.y);
    draw_scale.y= 1 - min( _impactForce * 0.1, 0.3);
    draw_scale.x= (1 + min( _impactForce * 0.05, 0.15)) * sign(draw_scale.x);
    
    

}

// Transition draw scale back to normal
if(draw_scale.x != image_xscale || draw_scale.y != image_yscale){
    draw_scale.x= lerp( draw_scale.x, image_xscale * sign(draw_scale.x), 0.25);
    draw_scale.y= lerp( draw_scale.y, image_yscale * sign(draw_scale.y), 0.25);
}
