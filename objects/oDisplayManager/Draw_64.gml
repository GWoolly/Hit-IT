/// @description 




//
//if(surfaceGUI.Exists() == true){
//	//draw_surface_stretched(surfaceGUI.id, 0, 0, 1, 1)
//}


draw_set_color(c_blue)

if(oCamera.follow != noone){
    var _follow= oCamera.follow;
    var _cf= string($"{object_get_name(_follow.object_index)}, velocity:({_follow.velocity.x},{_follow.velocity.y})")
}
else{
    var _cf= "noone"
}
var cf= oCamera.follow;
strings=[
	$"Scale: {GAME_SCALE}",
	$"Room: {room_get_name(room)}",
	$"Follow:{_cf}",
	$"Cam: velocity:({oCamera.x - oCamera.xprevious},{oCamera.y - oCamera.yprevious})"
];
for(var i= 0, iEnd= array_length(strings);	i < iEnd;	i++){
	draw_text(0,0 + (16 * i), strings[i]);
}

draw_set_color(c_white)


// debug screenspace
//draw_circle(0, 0, 2, false)
//draw_rectangle(0, 0, (width*scale)-1, (height*scale)-1, true)