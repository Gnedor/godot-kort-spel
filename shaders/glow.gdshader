shader_type canvas_item;

uniform float speed;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 final_color = texture(TEXTURE, UV);

	float target = 1.0f - fract(TIME * speed);

	float diag_uv = fract(UV.x - UV.y);
	float raw_dist = abs(diag_uv - target);

	float dist = min(raw_dist, 1.0 - raw_dist);

	final_color.rb += dist;

	COLOR = final_color;
}
