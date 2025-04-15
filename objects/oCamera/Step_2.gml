/// @description Update camera position

/*
camera_step_deadzone();
/*/
//fsm.step();

camera_move_trap_platformer(trap, follow, 0.1);

velocity.limit(8);
x+= velocity.x;
y+= velocity.y;

var _targetX= x //+ offset.x;
var _targetY= y //+ offset.y;
camera_set_view_mat(camera, matrix_build_lookat(_targetX, _targetY, z, _targetX, _targetY, 0, rotation.x, rotation.y, rotation.z));