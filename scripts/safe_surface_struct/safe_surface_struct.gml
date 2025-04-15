/// @desc  Constructs a surface that is safer than regular GMS surfaces.
/// @param {real} _width  Description
/// @param {real} _height  Description
/// @param {constant.surfaceformattype} [_format]=  surface_rgba8unorm Description
/// @param {string} [_name]=""  Description
function safe_surface_struct(_width, _height, _format= surface_rgba8unorm, _name="") constructor {	
	
	/// @desc Check if the surface exists
	/// @returns {bool} Returns true if the surface exists
	static Exists = function(){
		return surface_exists(self.id);
	};
	
	/**
	 * Function Description
	 */
	static Create = function(){
		if( surface_exists(self.id)==false){
			if(struct_exists(global.safeSurfaces, string(self.id))==true){ struct_remove(global.safeSurfaces, string(self.id));}
			
			//*
			self.id = surface_create(width, height, format);
			/*/
			surface= surface_create(width, height, format);
			/*///
			
			global.safeSurfaces[$ string(self.id)]= {
				format: format,
				size: size,
				instance: other.id,
			};
		}
	};
	
	static Predraw = function(){
		if surface_exists(self.id)==false{
			self.Create()
			return false;
		}
		return true;
	};
	
	static Resize= function(_width, _height){
		size= (_width>_height)? power(2, ceil(log2(_width))) : power(2, ceil(log2(_height))); // Get nearest power of 2 size for surface.
		width= _width;
		height= _height;
		aspect= (max(_width,_height)/size)*(_width/_height);
		
		//*///
		if(surface_exists(self.id)==true){
			Free();
		}
		Create();
	};
	
	static Free= function(){
		struct_remove(global.safeSurfaces, string(self.id));
		surface_free(self.id);
	};
	
	// Variables
	//==========
	self.id= noone;	
	name= _name
	
	size= (_width>_height)? power(2, ceil(log2(_width))) : power(2, ceil(log2(_height))); // Get nearest power of 2 size for surface.
	width= _width;
	height= _height;
	aspect= _width/_height;
	// Feather disable once GM1044
	format= _format ?? surface_rgba8unorm;
	
	//Finish creation
	Create();
};