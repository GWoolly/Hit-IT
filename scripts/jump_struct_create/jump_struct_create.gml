/// @desc Creates all the variables needed for an actor to jump.
/// @param {real} height			Maximum height of the jump.
/// @param {real} duration			Maximum duration of the jump.
/// @param {real} [apexHeight]=1.0	Percentage of jump height to apply apex gravity.
/// @param {real} [apexGravity]=1.0 Percentage of gravity applied during the jump apex.
/// @param {real} [coyoteTime]=0	Max coyote time.
/// @param {real} [bufferTime]=0	Max buffer time.
function jump_struct_create(height, duration, apexHeight= 1.0, apexGravity= 1.0, coyoteMax= 0, bufferMax= 0, heightMin= 0) constructor{
    
	// Jump config
	//============
	self.height= height;		// Height in pixels
	self.duration= duration;	// How long jump lasts
	
	self.heightMin= heightMin;	// Min height in pixels before variable jump can be applied.
	
	self.apexHeight= apexHeight;	// Percentage of speed
	self.apexGravity= apexGravity;	// Percentage gravity
	
	self.bufferMax= bufferMax;		// Time prior to touching the floor that the jump input is recognised.
	self.coyoteMax= coyoteMax;		// Time after leaving the ground that the jump input is recognised.
	
	
	/* Jump velocity variables
	 * =======================
	 * These values must be recalculated any time the jump height or duration changes!
	 */
	self.speed= jump_get_speed(height, duration);		// Initial jump velocity.
	self.gravity= jump_get_gravity(height, duration);	// Gravity applied to the jump velocity.
	
	self.heightMinSpeed= jump_get_speed(heightMin, duration);	// If velocity is larger than this value, then the variable jump height is applied.
	
	self.apexSpeed= self.speed * apexHeight;
	self.apexGravity= self.gravity * apexGravity;
	
	
	// Dynamic variables
	// =================
	// These values are used within jump_step to check if the actor can jump.	
	//self.onGround= false;	// Actor can jump if on the ground. // BUG: Disabled due to move_to_collision handling this variable at the instance level.
	self.buffer= 0;	// Can jump if jump buffer time is >= 0
	self.coyote= 0;	// Can jump if jump coyote time is >= 0
	
	self.velocity= 0;	// Current jump velocity when using angular jumps
	
}