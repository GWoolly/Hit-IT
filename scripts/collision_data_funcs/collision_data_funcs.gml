enum COLLISION {
	NONE,
	AXIS_X,
	AXIS_Y,
	
	TILE= 0,
	INSTANCE= 1,
}

/**
 * Crates the instance collision data for use in a collision handler callback
 * @param {any*} instanceID		The instance's id
 * @param {real} affectee_x		The position of where the collision occured, including velocity.
 * @param {real} affectee_y		The position of where the collision occured, including velocity.
 * @param {real} [axis_checked]=axis_none	The axis that was being checked.
 */
function collision_data_instance_create(instanceID, affectee_x, affectee_y, axis_checked= axis_none) constructor{
	//Can be found within collision_data_create_tile()
	//#macro axis_none 0
	//#macro axis_x 1
	//#macro axis_y 2
	
	isInstance= true;
	axis= axis_checked;
	id= instanceID;
	x= affectee_x;
	y= affectee_y;
	//self.layer= instanceID.layer;
} 


/**
* Crates the tile collision data for use in a collision handler callback
*
* @param {real} tile_data       The tile data of the tile that was found.
* @param {real} affectee_x		The position of where the collision occured, including velocity.
* @param {real} affectee_y		The position of where the collision occured, including velocity.
* @param {real} [axis_checked]=axis_none	The axis that was being checked.
* @param {real} [layer]=layer	The layer id of the tilemap.
*/
function collision_data_tile_create(tile_data, affectee_x, affectee_y, axis_checked= axis_x, layer= layer) constructor{
	#macro axis_x 0
	#macro axis_y 1
	#macro axis_none noone
	
	isInstance= false;
	axis= axis_checked;
	id= tile_data;
	x= affectee_x;
	y= affectee_y;
	self.layer= layer;
} 