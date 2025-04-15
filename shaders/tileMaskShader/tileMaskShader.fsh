// Fragment shader
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform int u_isDrawingTiles;     // 1 when drawing tmTiles, 0 when drawing bgSand

void main()
{
    vec4 texColor = texture2D(gm_BaseTexture, v_vTexcoord);
    
    if (u_isDrawingTiles == 1) {
        // When drawing tmTiles 
        
        // Make transparent pixels actually transparent
        if (texColor.a < 0.01) {
            discard;
        }
        
        // Check exactly for magenta (#ff00ff)
        // Using exact comparison for GLSL ES 1.0
        if (texColor.r > 0.99 && texColor.g < 0.01 && texColor.b > 0.99) {
            discard; // Skip drawing magenta pixels
            //*
            //gl_FragColor = vec4(0.0, 0.0, 1.0, 0.0);
            /*/
            gl_FragColor = texColor * v_vColour;
            //*/
        }
        else{
            /*
            // Debug: Red for tiles
            gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0);
            /*/
            // Normal rendering (uncomment this and comment debug line for final version)
            gl_FragColor = texColor * v_vColour;
            //*/
        }
    } else {
        // When drawing bgSand (stencil buffer controls where this gets rendered)
        
        /*
        // Debug: Green for sand
        gl_FragColor = vec4(0.0, 1.0, 0.0, 1.0);
        /*/
        // Normal rendering (uncomment this and comment debug line for final version)
        gl_FragColor = texColor * v_vColour;
        //*/
    }
}