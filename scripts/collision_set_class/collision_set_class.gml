/// @desc Sets the collisionClass variable of an instance
/// @param {integer} collision_flags    Numeric value of all flags added from COLLISION_FLAG.
function collision_set_class(collision_flags){
    
    // Initialise instance's collision class
    if(variable_struct_exists(self.id, "collisionClass") == false){
        collisionClass= collision_flags;
        return collision_flags;
    }
    
    
   
}