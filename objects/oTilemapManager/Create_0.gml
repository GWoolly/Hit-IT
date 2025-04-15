/// @description 
force_single_instance();;

#macro TILE_LAYER_PREFIX "tm"
#macro TILE_LAYER_DATA oTilemapManager.roomLayers

roomLayers=[];//All layers in the current room.
tileLayers=[];//Trimmed array of tile layer indexes.


global.tileLayers= [];//Array containing all tilemaps within the current room.


room_prior= noone;//The previous room that was loaded, not to be confused for room_previous!
//event_perform(ev_other, ev_room_start);