shader_type spatial;

uniform sampler2D base_texture;

const vec2 OFFSETS[9] = {
	vec2(-1, -1), vec2(-1, 0), vec2(-1, 1),
	vec2(0, -1), vec2(0, 0), vec2(0, 1),
	vec2(1, -1), vec2(1, 0), vec2(1, 1)
};

void fragment() {
	vec4 tex = texture(base_texture, UV);
	float surrounding_alpha = 0.0;
	
	for (int i = 0; i < OFFSETS.length(); i++) {
		surrounding_alpha += texture(base_texture, UV + OFFSETS[i]).a;
	}
	
	if (surrounding_alpha > 0.0) {
		ALPHA = 1.;
	}
	else {
		ALPHA = 0.;
	}
	
	ALBEDO = tex.rgb;
	ALPHA = tex.a;
}
