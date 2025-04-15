/// @description Populate array of Tilemap layers
	
var _roomLayers= layer_get_all();
roomLayers= {};
tileLayers= [];
	
for(var i= 0, iEnd= array_length(_roomLayers);	i < iEnd;	i++){
		
	var _layerID= _roomLayers[i];
	var _layerName= layer_get_name(_layerID);
		
	// Create struct for layer
	roomLayers[$ _layerID]={
		name: _layerName,
		id: _layerID,
			
		x: layer_get_x(_layerID),
		y: layer_get_y(_layerID),
		xprevious: layer_get_x(_layerID),
		yprevious: layer_get_y(_layerID),
			
		velocity: new vec2(),
	};
		
	if( string_pos(TILE_LAYER_PREFIX, _layerName ) > 0){
		array_push(tileLayers, _layerID);
	}
}
	
exit;

	//room_prior= room;//Update previous room to current
	
	//var _layers= layer_get_all();
	//var _layerCount= array_length(_layers);
	//global.tileLayers= array_create(_layerCount, noone);
	//myLayers= [];

	
	//// Add defined tilemaps to array
	////==============================
	//with(oTilemapObject){
	//	//index= array_get_index(_layers, layerID);
	//	global.tileLayers[layerID]= id;
	//}
	
	////Populate global.tileLayers with valid tilemap layers
	////====================================================
	//for(var i= _layerCount-1;		i >=0;		i--){
		
	//	// Process if is valid tile layer
	//	if( global.tileLayers[i] == noone){
			
	//		var _layerID= _layers[i];
	//		var _layerName= layer_get_name(_layerID);
			
	//		// Add tilemap layer to global list
	//		//=================================
	//		if(string_pos(TILE_LAYER_PREFIX, _layerName) == 1){
				
				
	//			var _index= array_get_index(_layers, _layerID);
				
	//			global.tileLayers[_layerID]={
	//				name: layer_get_name(_layerName),
	//				x: layer_get_x(_layerID),
	//				y: layer_get_y(_layerID),
	//				xprevious: layer_get_x(_layerID),
	//				yprevious: layer_get_y(_layerID),
	//				velocity: new velocity_create(layer_get_hspeed(_layerID), layer_get_vspeed(_layerID)),
	//			}
				
	//			// Add array reference to quick update list
	//			array_push(myLayers, _index);
				
	//		}
	//	}
	//}

