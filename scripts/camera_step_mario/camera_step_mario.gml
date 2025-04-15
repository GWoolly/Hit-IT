function camera_step_mario(){
    if(follow == noone){exit;}
        /// Camera object movement script for a New Super Mario-style game
        // Place this in the Step event of the camera object
        
        // Camera follows the player with a modern, smooth tracking system
        var _player = follow; // Change this to your player object
        var _camSpeed = 8;        // Faster smoothing speed for a responsive feel
        
        // Get the player's position
        var _playerX = _player.x;
        var _playerY = _player.y;
        
        // Define margins for the camera to follow the player
        var _xMargin = 150;  // Horizontal margin (in pixels)
        var _yMargin = 100;  // Vertical margin (in pixels)
        
        // Calculate the target position for the camera
        var _targetX = x;
        var _targetY = y;
        
        if (_playerX < x - _xMargin) {
            _targetX = _playerX + _xMargin;
        } else if (_playerX > x + _xMargin) {
            _targetX = _playerX - _xMargin;
        }
        
        if (_playerY < y - _yMargin) {
            _targetY = _playerY + _yMargin;
        } else if (_playerY > y + _yMargin) {
            _targetY = _playerY - _yMargin;
        }
        
        // Smoothly move the camera towards the target position
        x = lerp(x, _targetX, 1 / _camSpeed);
        y = lerp(y, _targetY, 1 / _camSpeed);
        
        // Apply the new camera matrix
        camera_set_view_mat(view_camera[0], matrix_build_lookat(x, y, 10, x, y, 0, 0, 1, 0));
}