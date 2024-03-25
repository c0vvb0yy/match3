shader_type canvas_item;

uniform vec3 color_up : source_color;
uniform vec3 color_down : source_color;
//uniform sampler2D bg_texture : source_texture;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 flipped_uv = vec2(1.0 - UV.x, UV.y);
	if (flipped_uv.x <= flipped_uv.y){//if (bg_col.x == 1.0){
		COLOR = vec4(color_down, 1.0);
	}
	else {
		COLOR = vec4(color_up, 1.0);
	}
	
	//COLOR = vec4(UV, 0.0,1.0);
	
	/*vec4 bg_col = texture(TEXTURE, UV);
	if(bg_col.x > 0.0){
		COLOR = vec4(color_down, 1.0);
	}
	else {
		COLOR = vec4(color_up, 1.0);
	}*/
}
