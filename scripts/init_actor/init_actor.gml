function init_actor(){
	velocity= new vec2();
    velocity_previous= new vec2();
	onGround= false;
    
    draw_scale= {// Juice! Scales sprite without affecting collision mask
        x: other.image_xscale,
        y: other.image_yscale,
    }
}