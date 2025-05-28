shader_type canvas_item;

uniform int parent_id;

uniform sampler2D imageOG;
uniform sampler2D imageSPACE;

uniform float epsilon = 0.0001;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	if (parent_id == 4) {
		vec4 this_pxl = texture(TEXTURE, UV);
		
		ivec2 image_size = textureSize(imageOG, 0);
		bool loop_done = false;
		
		for (int i = 0; i < image_size.x; i++) {
			float f = float(i);
			vec2 uv = vec2(f +0.5, 0.0) / vec2(image_size);
			//uv = vec2(4.0,0.5) / vec2(image_size);
			vec4 that_color = texture(imageOG, uv);
			
			if (length(this_pxl - that_color) < epsilon) {
				if (parent_id == 4) {
					COLOR = texture(imageSPACE, uv);
				}
				loop_done = true;
			}
			else if (!loop_done)
				COLOR = this_pxl;
		}
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
