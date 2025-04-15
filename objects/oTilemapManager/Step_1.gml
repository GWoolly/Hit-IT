/// @description Update layer info

array_foreach(tileLayers, function(_element, _index){
	
	var _layer= roomLayers[$ _element];
	
	_layer.x= layer_get_x(_element);
	_layer.y= layer_get_y(_element);
	
	_layer.velocity.x= _layer.x - _layer.xprevious;
	_layer.velocity.y= _layer.y - _layer.yprevious;
	
	_layer.xprevious = _layer.x;
	_layer.yprevious = _layer.y;
});