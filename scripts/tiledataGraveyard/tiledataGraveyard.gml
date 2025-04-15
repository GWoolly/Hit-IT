function tiledataGraveyard(in){
    static data = undefined;
    
    if data == undefined{
        
        var _count = tileset_get_info(tsSand)[$ "tile_count"];
        data =array_create(tileset_get_info(tsSand)[$ "tile_count"], COLLISION_FLAG.NONE);
        
        // Create DS grid
        var _tsInfo = tileset_get_info(tsSand);
        var _cols= _tsInfo.tile_columns
        var _rows= _tsInfo.tile_count / _cols;
        var _grid= ds_grid_create(_cols, _rows)
        ds_grid_clear(_grid, COLLISION_FLAG.NONE);
        
        // Regions
        ds_grid_set_region(_grid, 1,0, 5,3, COLLISION_FLAG.SOLID);// Sand
        
        // Manual
        //=======
        _grid[# 6,0]= COLLISION_FLAG.PLATFORM;
        _grid[# 7,0]= COLLISION_FLAG.PLATFORM;
        
        
        // Covert to tile ids
        for(var iy= 0; iy<_rows; iy++){
            for(var ix= 0; ix<_cols; ix++){
                data[ix + (iy * _cols)]= _grid[# ix, iy];
            }
        }
        show_debug_message($"grid: \n{_grid}\n");
        ds_grid_destroy(_grid)
        
        show_debug_message($"data= {data}")
    
        // Platform
        //data[7]= COLLISION_FLAG.PLATFORM;
        //data[8]= COLLISION_FLAG.PLATFORM;
        //
        //// None    
        //data[10]= COLLISION_FLAG.NONE;
        //data[20]= COLLISION_FLAG.NONE;
        //data[9]= COLLISION_FLAG.NONE;
    }

    
    
    
    
    return data[in & tile_index_mask];
    //switch(in){
        //case 7:
        //case 8:
            //return COLLISION_FLAG.PLATFORM;
        //
        //case 10:
            //return COLLISION_FLAG.NONE;
        //case 20:
            //return COLLISION_FLAG.NONE;
        //default:
            //return COLLISION_FLAG.SOLID;
    //}
}