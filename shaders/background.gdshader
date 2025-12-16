shader_type spatial;

uniform sampler2D backgorund_tex;
uniform sampler2D noise_tex;

void fragment() {
	vec2 distortion = 2.0 * texture(noise_tex, UV).rg - vec2(1.0);
	vec3 albedo = vec3(
		clamp(
			round(texture(backgorund_tex, UV + distortion * 0.5 + TIME * 0.075).rgb
		),
		0.45,
		0.9
	));
	
	albedo.r = 1. - albedo.r;
	albedo.rgb = albedo.rrr;
	
	ALBEDO = vec3(0.);
	ALBEDO += albedo;
	ALPHA = 0.5;
}
