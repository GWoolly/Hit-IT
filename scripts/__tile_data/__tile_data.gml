function tsdSand_create(){
    var _data= tile_collision_data_create(tsSand);
    
    // Solid
    ds_grid_set_region(_data, 1,0, 5,3, TILE_FLAG.ALL);
    
    // Platform
    _data[# 6,0]= TILE_FLAG.TOP;
    _data[# 7,0]= TILE_FLAG.TOP;
    
    tile_collision_data_bake(_data);
}
tsdSand_create();

enum TILE_FLAG {
    // Add a '0' at the end of each new flag!
    NONE=   0,
    ALL=    0b1111, /* All sides are solid = 15 */
    LEFT=   0b1,
    TOP=    0b10,
    RIGHT=  0b100,
    DOWN=   0b1000,
}