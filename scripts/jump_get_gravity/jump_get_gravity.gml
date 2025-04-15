/// @desc Gets the gravity to be applied to the jump.
/// @param {real} height	Max height of the jump.
/// @param {real} duration	Max duration of the jam.
/// @returns {real}			Gravity speed.
function jump_get_gravity(height, duration){
		return ((2 * height) / power(duration,2));
}