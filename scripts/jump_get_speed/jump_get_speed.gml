/// @desc Gets the initial jump velocity of the jump.
/// @param {real} height	Max height of the jump.
/// @param {real} duration	Max duration of the jam.
/// @returns {real}			Initial jump speed.
function jump_get_speed(height, duration){
	return -((2 * height) / duration);
}
