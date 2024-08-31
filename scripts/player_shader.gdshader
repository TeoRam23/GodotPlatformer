shader_type canvas_item;

uniform vec4 origin1:source_color;
uniform vec4 new1:source_color;
uniform vec4 origin2:source_color;
uniform vec4 new2:source_color;
uniform vec4 origin3:source_color;
uniform vec4 new3:source_color;
uniform vec4 origin4:source_color;
uniform vec4 new4:source_color;
uniform vec4 origin5:source_color;
uniform vec4 new5:source_color;
uniform vec4 origin6:source_color;
uniform vec4 new6:source_color;

uniform float epsilon = 0.0001;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 this_pxl = texture(TEXTURE, UV);
	
	if (length(this_pxl - origin1) < epsilon)
		COLOR = new1;
	else if (length(this_pxl - origin2) < epsilon)
		COLOR = new2;
	else if (length(this_pxl - origin3) < epsilon)
		COLOR = new3;
	else if (length(this_pxl - origin4) < epsilon)
		COLOR = new4;
	else if (length(this_pxl - origin5) < epsilon)
		COLOR = new5;
	else if (length(this_pxl - origin6) < epsilon)
		COLOR = new6;
	else
		COLOR = this_pxl;
	// Called for every pixel the material is visible on.
}


//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
