
/**
 * Creates a camera trap struct which is used as a deadzone for any which moves the camera so that an instance confines a target instance 
 * @param {real} width Width of the camera's deadzone.
 * @param {real} height Height of the camera's deadzone.
 * @param {real} [offset_x]=0 The x offset.
 * @param {real} [offset_y]=0 The y offset.
 */
function camera_trap_create(width, height, offset_x= 0, offset_y= 0) constructor{
    
    // Box config
    self.width= width;
    self.height= height;
    x= offset_x;
    y= offset_y;
    
    // Box rectangle
    var _halfW= width >> 1;
    var _halfH= height >> 1;
    left= x - _halfW + other.x;
    right= left + width;
    top= y - _halfH + other.y;
    bottom= top + height;
    
    //Platformer
    ground= bottom - offset_y;
}