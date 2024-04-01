shader_type canvas_item;


uniform float _Texture_Offset_x : hint_range(-1000.0, 1000.0, 1);
uniform float _Texture_Zoom : hint_range(-1000.0, 1000.0, 1);
uniform float _Max_Iterations : hint_range(0.0, 100.0, 0.1);
uniform float _Threshold : hint_range(0.0, 10.0, 0.1);
uniform float _Samples : hint_range(0.0, 10.0, 0.1);

uniform sampler2D _Dither_Texture;

uniform vec4 _Color0 : source_color;
uniform vec4 _Color1 : source_color;
uniform vec4 _Color2 : source_color;
uniform vec4 _Color3 : source_color;
uniform vec4 _Color4 : source_color;

struct palette {
    vec3 c0, c1, c2, c3, c4;
};
palette palette_calm_blue() {
    palette p; 
    p.c0 = vec3(5,8,49)/255.;
    p.c1 = vec3(19,48,114)/255.;
    p.c2 = vec3(213,230,247)/255.;
    p.c3 = vec3(213,230,247)/255.;
    p.c4 = vec3(5,8,49)/255.;
    return p;    
}

palette custom_palette(){
	palette p;
	p.c0 = _Color0.rgb;
	p.c1 = _Color1.rgb;
	p.c2 = _Color2.rgb;
	p.c3 = _Color3.rgb;
	p.c4 = _Color4.rgb;
	return p;
}

float random (in vec2 st) {
    return fract(sin(dot(st.xy,
                         vec2(12.9898,78.233)))*
        43758.5453123);
}

uniform float _Rand_Seed = 0.;

vec2 nextRand2() {
	float randSeed = _Rand_Seed;
    vec2 v = vec2( randSeed++, randSeed++ );
	return vec2( random( v+0.34 ), random( v+0.75 ) );    
}


vec3 colorMap( float t, palette p) {
    vec3 col = vec3(0);
	col = mix( p.c0,  p.c1, smoothstep(0. , .2, t));
    col = mix( col, p.c2, smoothstep(.2 , .4, t));
    col = mix( col, p.c3, smoothstep(.4 , .6, t));
    col = mix( col, p.c4, smoothstep(.6,  .8, t));
    col = mix( col, p.c0, smoothstep(.8, 1.,  t));
    return col;
}

float ship(vec2 uv,float _iter){
	vec2 c = 0.1*(uv - vec2(.2,0)) - vec2(1.74,0.035); 
    vec2 z = vec2(0); 
    float i = 0.;
    
    for(; ++i <= _iter ;) {
        z = abs(z);
        z = mat2(z, vec2(-z.y, z.x)) * z + c;
    	if( dot(z,z) > _Threshold ) break;
	}
  
    float l2 = log(2.);
    return i - log(log(dot(z,z))/l2)/l2;
}

void fragment() {
	vec2 _resolution = 1.0/TEXTURE_PIXEL_SIZE;///vec2(4.0,2.0);
	_resolution += vec2(_Texture_Offset_x, _Texture_Zoom);
	palette pal = custom_palette();
    
    vec3 col = vec3(0);
	float _max_iter = sin(TIME*.1+4.7)*20.+25.;
    for(float i=0.; i < _Samples; i++) {
        vec2 p = 0.5*(2.*FRAGCOORD.xy-_resolution)/_resolution.y ;
        float orbit = ship(p, _max_iter) / _max_iter;
    	col += colorMap(orbit, pal); 
    }
    
    col /= _Samples;

    COLOR = vec4(col, 1.);
	
	//COLOR = vec4(dither_value);
	
}
