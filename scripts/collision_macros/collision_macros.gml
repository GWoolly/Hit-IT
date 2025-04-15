
/* Collision Retrieving Info
 * =========================
 * 
 * These macros retrieve information about the current collision encountered -
 *  and are used to identify how to handle the instance colliding with the tile or instance.
 * 
 * The data retrieved is created by the collision_data functions.
 */


// Collision type
//---------------
#macro COLLISION_IS_INSTANCE move_to_collision.data.isInstance /* Returns if the current collision is an instance. */
#macro COLLISION_IS_TILE (!move_to_collision.data.isInstance) /* Returns if the current collision is a tile. */

// Collision axis
//---------------
#macro COLLISION_GET_AXIS (move_to_collision.data.axis) /* Returns the current axis that is being checked for collisions. */
#macro COLLISION_AXIS_NONE (0)
#macro COLLISION_AXIS_X (1)
#macro COLLISION_AXIS_Y (2)

// Collision coordinates
//----------------------
#macro COLLISION_GET_X move_to_collision.data.x /* Returns the current X coordinates of the collision. */
#macro COLLISION_GET_Y move_to_collision.data.y /* Returns the current Y coordinates of the collision. */

// Collision info
//---------------
#macro COLLISION_GET_ID move_to_collision.data.id /* Returns the id of the colliding Instance or raw Tile data. */
#macro COLLISION_GET_ID_TILE_INDEX (move_to_collision.data.id & tile_index_mask) /* Returns the Tile's index. */
#macro COLLISION_GET_LAYER (move_to_collision.data.layer) /* Returns the layer id */


/* Collision Returning Info
 * ========================
 * 
 * These macros send data back to the move_to_collision function, and are used after the collision has been handled.
 */
#macro COLLISION_FLAG_COLLIDED move_to_collision.collided /* Instructs the move_to_collision function that a collision has been made and to move on to next axis. */
#macro COLLISION_FLAG_CORNER_SMOOTHING move_to_collision.is_smoothing_corner /* Used in the Y-axis checks and instructs the move_to_collision function to ignore collisions on the X-axis for the current tile or instance collision check. */
#macro COLLISION_AXIS_BREAK move_to_collision.collided= 2
