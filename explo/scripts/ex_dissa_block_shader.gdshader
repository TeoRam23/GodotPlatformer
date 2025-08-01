shader_type canvas_item;

uniform int parent_id;

uniform sampler2D imageGRASS;
uniform sampler2D imageOG;
uniform sampler2D imageLAVA;
uniform sampler2D imageSPACE;

uniform float epsilon = 0.001;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	if (parent_id != 0 && parent_id != 2) {
		vec4 this_pxl = texture(TEXTURE, UV);
		
		ivec2 image_size = textureSize(imageOG, 0);
		bool loop_done = false;
		
		for (int i = 0; i < image_size.x; i++) {
			float f = float(i);
			vec2 uv = vec2(f +0.5, 0.0) / vec2(image_size);
			//uv = vec2(4.0,0.5) / vec2(image_size);
			vec4 that_color = texture(imageOG, uv);
			
			//if (1==1){
				////COLOR = vec4(0, 0, 0, 255);
				//if (parent_id == 1) {
					//COLOR = texture(imageGRASS, uv);
				//} else if (parent_id == 3) {
					//COLOR = texture(imageLAVA, uv);
				//} else if (parent_id == 4) {
					//COLOR = texture(imageSPACE, uv);
				//}
				//loop_done = true;
				// JEG MÅ FINNE UT HVORDAN JEG FÅR PARTIKLER ENDRET; IDK
				
				if (length(that_color-COLOR.rgba)<0.001){
				if (parent_id == 1) {
					COLOR = texture(imageGRASS, uv);
				} else if (parent_id == 3) {
					COLOR = texture(imageLAVA, uv);
				} else if (parent_id == 4) {
					COLOR = texture(imageSPACE, uv);
				//COLOR = COLOR;
				loop_done = true;
				}
			}
			// denne er vanligvis uten else if btw
			//}else 
			//if (length(this_pxl - that_color) < epsilon || 1==2) {
			////if (COLOR == that_color) {
				//if (parent_id == 1) {
					//COLOR = texture(imageGRASS, uv);
				//} else if (parent_id == 3) {
					//COLOR = texture(imageLAVA, uv);
				//} else if (parent_id == 4) {
					//COLOR = texture(imageSPACE, uv);
				//}
				//loop_done = true;
			//}
			//else if (1==2){
				//COLOR == that_color;
			//}
			else if (!loop_done)
				int hey = 1;
				COLOR = COLOR;
				//COLOR = vec4(0, 0, 0, 255);
		}
	}
}
