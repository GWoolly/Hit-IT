/// @desc	Add acceleration to the velocity or apply friction when exceeding a max speed or no 
///
/// @param {real} acceleration	Signed acceleration to be applied to the velocity.
/// @param {real} friction		Unsigned friction to be applied when not accelerating.
/// @param {real} maxSpeed		Unsigned maximum velocity before friction is applied.
function velocity_x_add(acceleration, friction, maxSpeed){
	
	// Reduce speed
	velocity.x= sign(velocity.x) * max( abs(velocity.x) - (abs(friction * DELTA_RATIO)), 0); // Approach zero velocity
	
	// Accelerate as long as not going faster than the max speed in the accelerated direction
	if( abs(velocity.x) <= maxSpeed
	|| sign(velocity.x) != sign(acceleration) ){
		
		velocity.x= clamp( velocity.x + (acceleration * DELTA_RATIO), -maxSpeed, maxSpeed);
	}
}