/// @desc	Creates a waypoint to be used in a waypoints array.
///
/// @param {real} x									X position.
/// @param {real} y									Y position.
/// @param {real} [wait]=0							Wait time in frames.
/// @param {asset.gmanimcurve} [curve]=acLinear		Animation curve to use.
/// @param {real} [channel]=0						Animation channel to use.
/// @param {function} [callback]=No-Op				Callback to perform when the waypoint is reached.
function waypoint_create(x, y, wait= 0, curve= acLinear, channel= 0, callback= function(){}) constructor{
	
	//Waypoint struct
	//===============
	self.x= x;
	self.y= y;
	self.wait= wait;
	self.channel= animcurve_get_channel(curve, channel);
	
	self.callback= callback;
}




