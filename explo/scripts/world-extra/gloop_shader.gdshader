shader_type canvas_item;

// uniform sampler2D tex;
uniform vec4 inside_color:source_color;
uniform vec4 outline_color:source_color;



void vertex() {
	// Called for every vertex the material is visible on.

}

void fragment() {
	// Called for every pixel the material is visible on.
    vec2 tex_size = vec2(textureSize(TEXTURE, 0));
    vec2 uv = UV;
	
	float alpha = texture(TEXTURE, uv).a;
    if (alpha > 0.0) {
        COLOR = inside_color;
	} else {
		float edge = 0.0;
		for (float x = -1.0; x <= 1.0; x++) {
        	for (float y = -1.0; y <= 1.0; y++) {
				if (abs(x) != abs(y)) {
	            	vec2 offset = vec2(x, y) / tex_size;
	            	edge = max(edge, texture(TEXTURE, uv + offset).a);
				}
        	}
    	}
		if (edge > 0.0) {
        	COLOR = outline_color;
    	} else {
        	discard;
    }
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
