/// @description Init camera
velocity= new velocity_create(0.1, 0.5, 8);



//fsm= new camera_state_followFocus(32, 32, 8, 0, 0.1); // Not in use

smoothing= 0.25;
lookX= 0;// Offset that doesn't affect the camera's physical position
lookY= -16;// Offset that doesn't affect the camera's physical position


// Trap/Bounding Box
trap= new camera_trap_create(16, 128, 0, 16);
look_ahead = {
	// current
	x: 0,
	y: 0,
	
	// target
	tx: 16,
	ty: 0,
	
	smoothing: 0.1,
};

// View offset
//offset={
    //x: 0,
    //y: -16,
//}


/* Camera variables
 * ===================
 * @var {number}	camera		- The camera's id.
 * @var {number}	view		- The view that the camera is attached to.
 * @var {number}	surface		- The view_surface that the camera is drawing to.
 *
 * @var {number}	width
 * @var {number}	height
 * @var {float}		quality		- Multiplies the camera's resolution.
 */ 

#macro CAMERA_SURFACE	view_surface_id[view_index]

// Create the camera
//==================
camera= camera_create();
show_debug_message($"oCamera:{id}: created camera[{camera}].");


// Debug Visuals + BBox
//=====================
image_xscale= width * 0.1;
image_yscale= height * 0.1;



// GM Camera vars - Used in global.cameraList
//===========================================
global.cameraList[view_index]= self;
view_visible[view_index]= true;
view_visible[view_index]= active;
surface= view_surface_id[view_index];



// Draw scale for easy rendering of view_surface
//==============================================
update_drawScale= function(){
	var _test= GAME_SCALE 
	draw_scale= GAME_SCALE / quality;
}
update_drawScale();



// Positional vars
//================
x=	x;
y=	y;
z= -10;

rotation={// Y is up
	x: 0,
	y: dcos(image_angle),
	z: dsin(image_angle)
};

angle= image_angle;



// Camera Matrixes
//================
view_matrix= matrix_build_lookat(x,y,z,	x,y,0,	rotation.x,rotation.y,rotation.z);
proj_matrix= matrix_build_projection_ortho(width, height, 1.0, 32000.0);
camera_set_view_mat(camera, view_matrix);
camera_set_proj_mat(camera, proj_matrix);



// Camera Bounds
//==============




