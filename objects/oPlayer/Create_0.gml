/// @description 
show_debug_message($"oPlayer: Create");

init_actor();
collision_set_class(COLLISION_FLAG.PLAYER + COLLISION_FLAG.SOLID);


input= new input_create(new input_default_bindings());
input.bind("keyboard", "reset", [ord("R")]);//Test
//input.bind("gamepad", "reset", []);//Test

//if(live_call()){ 
//	show_debug_message($"GM-Live returning live_result! {live_result}")
//	return live_result;
//}

// Class variables
//================
walk= {
        speed: 0.5,
        friction: 0.45,
        max: 4,
};
jump= new jump_struct_create(48, 30, 0.9, 0.5, 30, 30, 24);
groundY= bbox_bottom;


//juice_camera= new camera_juice_shake_sine_create(0, 0.1, 0.9);

var _test= bbox_bottom - bbox_top;


//Collisions
tileCollisions= layers_get_ids(["tmTiles"]);
objectCollisions= [oSolid]

collisionTile= function(in){
    
    var _type= tiledataGraveyard(in.id);
    switch (_type){
        case COLLISION_FLAG.PLATFORM: return collide_oneway_platform(4);
            //if(in.axis == "y"){
                //var _collided= collide_oneway_platform(in, 4);
                //onGround= _collided;
                //return _collided;
            //}
            //else{
                //return false;
            //}
        case COLLISION_FLAG.SOLID:{//COLLISION_FLAG.SOLID
            if( in.axis == COLLISION.AXIS_Y){
                if( velocity.y >= 0){// Landing on ground
                
                onGround= true;
                    return collide_solid();
                }
                else{
                    //collide_solid( collide_corner_snap(in, 4, 0.75) );
					return collide_solid(true, 8, 1);
                }
            }
			else{
				return collide_solid(4, 0.75);
			}
            //return collide_solid(in);
        }
        default://COLLISION_FLAG.NONE
            return false;
    }
    //
    return false;
};

collisionCallback= function(in){
    var _stillColliding= true;
            
    if(COLLISION_IS_INSTANCE){
        
        switch(COLLISION_GET_ID.object_index){
            
            case oPlatform_static:	
                return collide_oneway_platform(4);//test temp disabled for collision executed in oPlatform
            
            default://oSolid
                if( COLLISION_GET_AXIS == COLLISION_AXIS_Y){
                    if( velocity.y >= 0){// Landing on ground
                    
                    onGround= true;
                        return collide_solid();
                    }
                    else{
						return collide_solid(4, 0.75);
                        //_stillColliding= collide_corner_snap(in, 4, 0.25);
                        //if(_stillColliding == true){
                            //return collide_solid(in);
                        //}
                        //else{
                            //return false;
                        //}
                    }
                }
				else{
                	return collide_solid(in);
				}
        }
    }
    else{//Tile Collision
        return collisionTile(in);
    }
};



states= {
    "walk": {
        step: function(){
            //live_name= "walk";
            //live_auto_call;
            
            
            // Get movement input
            if(input.gamepadID >= 0){//Using Gamepad
                var _keyX= clamp( (input.check_button("right") - input.check_button("left")) + input.check_axis("x"), -1, 1);
            }
            else{
                var _keyX= input.check_button("right") - input.check_button("left");
            }
            
            //Check if jumped
            var _keyJump= input.check_button_pressed("jump");
            var _hasJumped = jump_step(_keyJump);
            
            
            // Apply velocity
            velocity_x_add(walk.speed * _keyX, walk.friction, walk.max);
            
            

            move_to_collision(tileCollisions,objectCollisions,collisionCallback, 8);
            
            // Image flip
            if(velocity.x != 0){
                draw_scale.x= sign(velocity.x);
            }
        }
    },
    
};

state_add_default_events(states);

// Create StateMachine
fsm= new state_machine_create(states, "walk");


