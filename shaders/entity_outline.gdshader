shader_type spatial;

uniform sampler2D base_texture;

void fragment() {
	vec4 tex = texture(base_texture, UV);

	ALBEDO = tex.rgb;
	ALPHA = tex.a;
}
