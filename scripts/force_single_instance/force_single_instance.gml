/// @desc Forces a single instance of an object. Any additional instances are destroyed without their destroy action being performed.
function force_single_instance(){
    if( instance_number(self.object_index) > 1){
        instance_destroy(self.id, false);
    }
}