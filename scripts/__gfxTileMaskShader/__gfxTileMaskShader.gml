// Places a texture behind pixels that are r=255, g=000, b=255
// Use in the room start event
function layer_tileset_clippng_mask() {
    
    if( layer_exists("tmTiles")){
        var _layer = layer_get_id("tmTiles");
        
        scrShaderStart= function(){
            
            //show_debug_message($"start - t:{event_type} n:{event_number}")
            
            if(event_type == ev_draw && event_number == ev_draw_normal){
            
                
                //layer_set_visible("tmTiles", false);
                
                // Start fresh - reset all states
                                gpu_set_alphatestenable(false);
                                gpu_set_blendenable(true);
                                gpu_set_blendmode(bm_normal);
                                
                                
                                draw_clear_stencil(2);// Clear the stencil
                                gpu_set_stencil_enable(true);
                                gpu_set_stencil_write_mask(1);
                                gpu_set_stencil_pass(stencilop_replace);
                
                                gpu_set_stencil_ref(1)//new
                                
                                gpu_set_alphatestenable(true);
                                gpu_set_alphatestref(127);// <0.5 discarded
                                
                                
                                gpu_set_colorwriteenable(false, false, false, false);// write tilemap to buffer but not screen
                                
                                //draw_clear(#ff00ff);
                                draw_tilemap(layer_tilemap_get_id("tmTiles"), 0, 0);// Draw tilemap to buffer
                                
                                // Reeset buffers
                                gpu_set_alphatestenable(false);
                                gpu_set_colorwriteenable(true, true, true, true);
                                
                                gpu_set_stencil_ref(0);
                                gpu_set_stencil_read_mask(1);
                                gpu_set_stencil_pass(stencilop_keep);
                                gpu_set_stencil_func(cmpfunc_notequal);// buffer value noteq to ref, keep fragment else discard
                                
                                // Draw sprite
                // draw tilemap
                shader_set(tileMaskShader);
                static u_isDrawingTiles = shader_get_uniform(tileMaskShader, "u_isDrawingTiles");
                shader_set_uniform_i(u_isDrawingTiles, 0); // Tell shader we're drawing sand
                
                                draw_sprite_tiled(sprSandBG, 0, 0, 0);
                                gpu_set_stencil_enable(false);
                                
                shader_set_uniform_i(u_isDrawingTiles, 1); // Tell shader we're drawing the tilemap
                                
            }
    
        }
        layer_script_begin( _layer, scrShaderStart);
        
        
        scrShaderEnd= function(){ 
            
            //show_debug_message($"end - t:{event_type} n:{event_number}")
            //layer_set_visible("tmTiles", true);
            if(event_type == ev_draw && event_number == ev_draw_normal){
                
                shader_reset();
                
                
                // Draw tilemap and remove purple
                
                
                
                //// old working
                //// Clear the screen/surface with transparent black
                ////draw_clear_alpha(c_black, 0); // This is bug!
                //
                //// Step 1: Setup stencil for detecting where tiles exist
                //gpu_set_stencil_enable(true);
                //gpu_set_stencil_write_mask(255);
                //gpu_set_stencil_read_mask(255);
                //
                //// Clear stencil buffer to 0
                //gpu_set_stencil_func(cmpfunc_always);
                //gpu_set_stencil_ref(0);
                //gpu_set_stencil_pass(stencilop_replace);
                //gpu_set_stencil_fail(stencilop_keep);
                //gpu_set_stencil_depth_fail(stencilop_keep);
                //
                //// Write to stencil only (no color output)
                //gpu_set_colorwriteenable(false, false, false, false);
                //
                //// Write 1 to stencil buffer where non-transparent tiles exist
                //// No shader needed for this pass
                //gpu_set_stencil_func(cmpfunc_always);
                //gpu_set_stencil_ref(1);
                //
                //// Store uniform handles for later use
                //static u_isDrawingTiles = shader_get_uniform(tileMaskShader, "u_isDrawingTiles");
                //
                //draw_tilemap(layer_tilemap_get_id(layer_get_id("tmTiles")), 0, 0);
                //
                //// Re-enable color writing
                //gpu_set_colorwriteenable(true, true, true, true);
                //
                //// Step 2: Draw sand background only where stencil is 1
                //shader_set(tileMaskShader);
                //gpu_set_stencil_func(cmpfunc_equal);
                //gpu_set_stencil_ref(1);
                //gpu_set_stencil_pass(stencilop_keep);
                //
                //shader_set_uniform_i(u_isDrawingTiles, 0); // Tell shader we're drawing sand
                //draw_sprite_tiled(sprSandBG, 0, 0, 0);
                //
                //// Step 3: Draw tiles with magenta filter
                //gpu_set_stencil_enable(false); // Turn off stencil testing
                //gpu_set_blendmode(bm_normal); // Normal blending
                //
                //shader_set_uniform_i(u_isDrawingTiles, 1); // Tell shader we're drawing tiles
                //draw_tilemap(layer_tilemap_get_id(layer_get_id("tmTiles")), 0, 0);
            //
                //// Cleanup
                //shader_reset();
                //gpu_set_stencil_enable(false);
                //gpu_set_blendmode(bm_normal);
                //
                
            }
    
        }
        layer_script_end(_layer, scrShaderEnd);
        
        show_debug_message("Assigned shader script")
    }
}