/// @desc Function Enables or disables the camera from rendering with the camera_draw functions.
/// @param {any*} _cameraID Camera to check if enabled.
function camera_get_enable(_cameraID){
	return global.cameraList[_cameraID].enable;
}


/// @desc Function Enables or disables the camera from rendering with the camera_draw functions.
/// @param {any*} _cameraID Camera to alter.
/// @param {bool} _bool Enable or disable the camera.
function camera_set_enable(_cameraID, _bool){
    var _camera = global.cameraList[_cameraID];
    
    _camera.enable = _bool;
    
    // Disable the view port.
    if( _camera.view >= 0
    &&	_camera.view < 8){
        view_visible[_camera.view] = _bool;
    }
}
