/// @desc Returns a point between the given values by the specified amount, without exceeding either value.
/// @param {real} a         Start point.
/// @param {real} b         End point.
/// @param {real} amount    How much to move towards the end position.
/// @returns {real} The new position between a and b.
function approach(a, b, amount){
	return (a <= b)?		min(a + amount, b)		:	max(a - amount, b);
}


/// @desc  Modulo that can handle negative values!
/// @param {real} value     Raw value.
/// @param {real} divisor   Max number before rolling over.
/// @returns {real}  Positive remainder of the divisor.
function modulo(value, divisor){
    return ((value % divisor) + divisor) % divisor;
}



/**
 * Returns the inverse lerp value.
 * @param {real} a          Start position.
 * @param {real} b          End position.
 * @param {real} position   The point between a and b.
 */
function lerp_inverse(a, b, position){
    return (position - a) / (b - a);
}


/**
 * Converts a value within a given input range to an output range.
 * @param {real} in_min     The minimum value of the original range.
 * @param {real} in_max     The maximum value of the original range.
 * @param {real} out_min    The minimum value of the output range.
 * @param {real} out_max    The maximum value of the output range.
 * @param {real} value      The value from within the output range to be converted to a point within the output range.
 * 
 * @returns {real}  Returns converted value within the output range.
 */
function remap(in_min, in_max, out_min, out_max, value){
    var _target= lerp_inverse(in_min, in_max, value);
    return lerp(out_min, out_max, _target);
}