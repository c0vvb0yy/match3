shader_type canvas_item;

uniform sampler2D noise_texture;

uniform float progress : hint_range(0,1);
uniform float decay_width :hint_range(0,0.5) = 0.06;
uniform vec4 decay_color : hint_color;

void fragment(){
	float width = 0.0;
	if(progress != 0.0){
		width = decay_width;
	}
	vec4 color = texture(TEXTURE, UV);
	float random_alpha = 0.0;
	vec4 fun_color = vec4(1.0, 1.0, 1.0, 1.0);
	if(texture(noise_texture, UV).r >= progress){
		random_alpha = texture(noise_texture, UV).a;
	}
	if(texture(noise_texture, UV).r <= progress + width){
		fun_color = decay_color;
	}
	fun_color.a = random_alpha;
	color.a *= random_alpha;
	if(fun_color.rgb != vec3(1.0,1.0,1.0)){
		color.rgb = vec3(fun_color.r, fun_color.g, fun_color.b);
	}
	COLOR = color;
}