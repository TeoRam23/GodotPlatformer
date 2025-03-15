shader_type canvas_item;

uniform sampler2D imageOG;
uniform sampler2D imageNEW;

uniform float epsilon = 0.0001;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 this_pxl = texture(TEXTURE, UV);
	
	ivec2 image_size = textureSize(imageOG, 0);
	bool loop_done = false;
	
	for (int i = 0; i < image_size.x; i++) {
		float f = float(i);
		vec2 uv = vec2(f +0.5, 0.0) / vec2(image_size);
		//uv = vec2(4.0,0.5) / vec2(image_size);
		vec4 that_color = texture(imageOG, uv);
		
		if (length(this_pxl - that_color) < epsilon) {
			COLOR = texture(imageNEW, uv);
			loop_done = true;
		}
		else if (!loop_done)
			COLOR = this_pxl;
	}
	
	
	// dette var slik jeg gjorde det før, se shader1
	//if (length(this_pxl - origin1) < epsilon)
		//COLOR = new1;
	//else if (length(this_pxl - origin2) < epsilon)
		//COLOR = new2;
	//else if (length(this_pxl - origin3) < epsilon)
		//COLOR = new3;
	//else if (length(this_pxl - origin4) < epsilon)
		//COLOR = new4;
	//else if (length(this_pxl - origin5) < epsilon)
		//COLOR = new5;
	//else if (length(this_pxl - origin6) < epsilon)
		//COLOR = new6;
	//else
		//COLOR = this_pxl;
	// Called for every pixel the material is visible on.
}


//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
