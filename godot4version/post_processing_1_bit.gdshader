shader_type canvas_item;

uniform float _power :hint_range(0.0, 10.0, 0.01); 
uniform float _dither_color_offset_x :hint_range(-100.0, 1000.0, 0.01);
uniform float _dither_color_offset_y :hint_range(-100.0, 1000.0, 0.01); 
uniform float _blue_outer_range :hint_range(0.0, 1.0, 0.01); //0.59
uniform float _blue_inner_range :hint_range(0.0, 1.0, 0.01); //0.63 <- both good values for a dither band
uniform float dither_threshold : hint_range(0.0, 1.0, 0.01);
uniform vec4 dither_color :source_color;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform sampler2D dither_texture;
// Blurs the screen in the X-direction.
void fragment() {
    vec3 col = texture(screen_texture, SCREEN_UV).xyz;
	float dither_value = texture(dither_texture, SCREEN_UV).x;//vec3(0);
	if (col.b < _blue_outer_range){
		col = vec3(0);
	}
	if (col.b >= _blue_inner_range){
		col = vec3(1);
	}
	
	
    if (col.b < _blue_inner_range && col.b > _blue_outer_range){
		col = vec3(1);
		if (dither_value < dither_threshold){
			//col = dither_color.rgb;
			vec2 col_offset = vec2(_dither_color_offset_x, _dither_color_offset_y);
			/*if(mod(POINT_COORD, vec2(2.))== vec2(0)){
				col_offset = -col_offset;
			}*/
			col += texture(screen_texture, SCREEN_UV + SCREEN_PIXEL_SIZE*col_offset).xyz * _power;
			col -= vec3(1.5);
		}
	}
	/*else{
		col = vec3(0);
	}*/
	/*
	vec2 screen_pos = FRAGCOORD.zw / FRAGCOORD.xy;
	vec2 dither_coordinate = screen_pos * (1.0/TEXTURE_PIXEL_SIZE) * vec2(1./8., 1./8.);
	float dither_value = texture(_Dither_Texture, dither_coordinate).r;*/
    COLOR.xyz = col;
}