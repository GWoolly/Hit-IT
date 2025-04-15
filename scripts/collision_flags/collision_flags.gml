/* COLLISION FLAGS
 * ===============
 * 
 * Use these flags to set the collision properties of tiles and instances.
 * 
 * Example:
 * ```
 * collision_flag= COLLISION_FLAG.SOLID + COLLISION_FLAG.ENEMY; // Makes the instance both solid and an enemy
 * ```
 */
enum COLLISION_FLAG {
		NONE=       0,
		SOLID=      0b1,
		PLATFORM=   0b10,
		ENEMY=      0b100,
		PLAYER=     0b1000
}// Add an extra 0 at the end of all new flags.



enum TILE_SOLID {
    NONE=	0,
    ALL=	0b1111,  // All directions (1+2+4+8=15)
    LEFT=	0b1,
    TOP =	0b10,
    RIGHT=	0b100,
    DOWN=	0b1000,
    
}