switch(async_load[? "event_type"]){
    case "gamepad discovered":
        var _test= true;
        break;
    case "gamepad lost":
        var _index= async_load[? "pad_index"]
    
        input_create.gamepadBlacklist[_index]= false;
        break;
}