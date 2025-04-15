#macro speed move_speed /*In-Built speed override, because it gets in my way!*/
#macro get value
#macro set value


/**
 *  Creates a vec2 velocity struct with a config variable for acceleration, friction and terminal velocity.
 * @param {real} accel  The acceleration added to the velocity.
 * @param {real} fric  The friction applied to the velicity.
 * @param {real} [max_speed]=10000  Maximum speed allowed.
 */
function velocity_create(accel, fric, max_speed= 10000) constructor{
	x= 0;
	y= 0;
    value= new speed_config_create(accel, fric, max_speed)
    
    static limit= function(x_speed= self.value.max, y_speed= x_speed){
        x= clamp(x, -x_speed, x_speed);
        y= clamp(y, -y_speed, y_speed);
    }
}


/**
 *  Creates a speed configuration struct.
 * @param {real} accel  The acceleration applied to the velocity.
 * @param {real} fric  The friction applied to the velocity.
 * @param {real} [max_speed]=10000  The maximum velocity.
 */
function speed_config_create(acceleration, friction, max_speed=10000) constructor{
    self.accel= acceleration;
    self.fric= friction;
    self.max= abs(max_speed);
}