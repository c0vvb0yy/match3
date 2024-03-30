shader_type canvas_item;

uniform sampler2D noise : repeat_enable;
uniform int numberOfColors : hint_range(1, 29);
uniform float distortionstrength : hint_range(-2.0, 2.0);
uniform vec2 flow_direction;
uniform vec4 main_tint : source_color;
uniform vec4 sec_tint : source_color;
uniform vec4 C1 : source_color;
uniform vec4 C2 : source_color;
uniform vec4 C3 : source_color;
uniform vec4 C4 : source_color;
uniform vec4 C5 : source_color;
uniform vec4 C6 : source_color;
uniform vec4 C7 : source_color;
uniform vec4 C8 : source_color;
uniform vec4 C9 : source_color;
uniform vec4 C10 : source_color;
uniform vec4 C11 : source_color;
uniform vec4 C12 : source_color;
uniform vec4 C13 : source_color;
uniform vec4 C14 : source_color;
uniform vec4 C15 : source_color;
uniform vec4 C16 : source_color;
uniform vec4 C17 : source_color;
uniform vec4 C18 : source_color;
uniform vec4 C19 : source_color;
uniform vec4 C20 : source_color;
uniform vec4 C21 : source_color;
uniform vec4 C22 : source_color;
uniform vec4 C23 : source_color;
uniform vec4 C24 : source_color;
uniform vec4 C25 : source_color;
uniform vec4 C26 : source_color;
uniform vec4 C27 : source_color;
uniform vec4 C28 : source_color;
uniform vec4 C29 : source_color;
/*
uniform float _step : hint_range(-2.0, 2.0, 0.01);
uniform float _frequency_a : hint_range(-2.0, 2.0, 0.01);
uniform float _frequency_b : hint_range(-2.0, 2.0, 0.01);

vec4 primitive_popcoren(vec2 uv, sampler2D tex){
	vec2 new_uv = uv;
	float stepp = sin(TIME*.5)*_step + 0.5;
	float facc = sin(TIME*0.5)*_frequency_a + 0.5;
	float faccc = sin(TIME*0.5)*_frequency_b + 0.5;
	uv.x = uv.x - stepp * sin(uv.y + tan(facc*uv.y));
	uv.y = uv.y - stepp * sin(uv.x + tan(faccc*uv.x));
	return texture(tex, uv).rgba;
}*/

void vertex(){
	//VERTEX += vec2(cos(TIME)*50.0, sin(TIME)*50.0);
}

void fragment() {
	vec4 referenceColors[29];
	referenceColors[0] = C1;
	referenceColors[1] = C2;
	referenceColors[2] = C3;
	referenceColors[3] = C4;
	referenceColors[4] = C5;
	referenceColors[5] = C6;
	referenceColors[6] = C7;
	referenceColors[7] = C8;
	referenceColors[8] = C9;
	referenceColors[9] = C10;
	referenceColors[10] = C11;
	referenceColors[11] = C12;
	referenceColors[12] = C13;
	referenceColors[13] = C14;
	referenceColors[14] = C15;
	referenceColors[15] = C16;
	referenceColors[16] = C17;
	referenceColors[17] = C18;
	referenceColors[18] = C19;
	referenceColors[19] = C20;
	referenceColors[20] = C21;
	referenceColors[21] = C22;
	referenceColors[22] = C23;
	referenceColors[23] = C24;
	referenceColors[24] = C25;
	referenceColors[25] = C26;
	referenceColors[26] = C27;
	referenceColors[27] = C28;
	referenceColors[28] = C29;
	
	vec4 noise_col = texture(noise, UV + flow_direction*TIME);
	vec2 uv = UV+(TIME*0.25-floor(TIME*0.25 +0.5)+0.5);
	uv += distortionstrength * noise_col.rr;
	vec4 textureCol = texture(TEXTURE, uv);
	int index = int(floor(textureCol.r * (float(numberOfColors))));
	//int index = int(floor(uv.r * (float(numberOfColors))));
	//index = int(abs(sin(TIME))*float(numberOfColors));
	textureCol.rgba = referenceColors[index];
	if (index % 2 == 0){
		textureCol.rgba *= main_tint;
	} else {
		textureCol.rgba *= sec_tint;
	}
	COLOR = textureCol;
	//COLOR = primitive_popcoren(UV, TEXTURE);
	//COLOR = vec4(uv, 0.0, 1.0);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
