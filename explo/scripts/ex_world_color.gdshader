shader_type canvas_item;

// dette MÅ være inkludert i et script for å få verden nummer: 
// var stage = get_tree().current_scene.name
// var world_number = stage.split()[0]
// pump_particle.material.set("shader_parameter/parent_id", int(world_number))
uniform int parent_id;
uniform float epsilon = 0.001;

uniform bool fyll_inn_ALLE_fargene = true;
uniform sampler2D imageGRASS_MAIN;
uniform sampler2D imageFALL;
uniform sampler2D imageLAVA;
uniform sampler2D imageSPACE;
uniform sampler2D imageFIVE;


void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	if (parent_id == 1 || parent_id == 2 || parent_id == 3 || parent_id == 4 || parent_id == 5) {
		vec4 this_pxl = texture(TEXTURE, UV);
		
		ivec2 image_size = textureSize(imageGRASS_MAIN, 0);
		bool loop_done = false;
		
		for (int i = 0; i < image_size.x; i++) {
			float f = float(i);
			vec2 uv = vec2(f +0.5, 0.0) / vec2(image_size);
			//uv = vec2(4.0,0.5) / vec2(image_size);
			vec4 that_color = texture(imageGRASS_MAIN, uv);
			
			//if (1==1){
				////COLOR = vec4(0, 0, 0, 255);
				//if (parent_id == 1) {
					//COLOR = texture(imageGRASS_MAIN, uv);
				//} else if (parent_id == 3) {
					//COLOR = texture(imageLAVA, uv);
				//} else if (parent_id == 4) {
					//COLOR = texture(imageSPACE, uv);
				//}
				//loop_done = true;
				
				// jeg vet ikke hvorfor 0.05 ikke bare kan være 0.01, kanskje jeg har et problem?
				if (distance(that_color, COLOR.rgba)<0.05){
				if (parent_id == 2) {
					COLOR = texture(imageFALL, uv);
				} else if (parent_id == 3) {
					COLOR = texture(imageLAVA, uv);
				} else if (parent_id == 4) {
					COLOR = texture(imageSPACE, uv);
				} else if (parent_id == 5) {
					COLOR = texture(imageFIVE, uv);
				}
				//COLOR = COLOR;
				loop_done = true;
			} else if (!loop_done)
				//int hey = 1;
				COLOR = COLOR;
				//COLOR = vec4(0, 0, 0, 255);
			// denne er vanligvis uten else if btw
			//}else 
			//if (length(this_pxl - that_color) < epsilon || 1==2) {
			////if (COLOR == that_color) {
				//if (parent_id == 1) {
					//COLOR = texture(imageGRASS_MAIN, uv);
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
		}
	}
}
