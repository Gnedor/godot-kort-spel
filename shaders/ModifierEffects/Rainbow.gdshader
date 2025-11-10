shader_type canvas_item;

uniform float speed = 0.5f;

float get_dist(float delay, float uv){
	float target = 1.0f - fract(TIME * speed + delay);
	float raw_dist = abs(uv - target);
	float dist = min(raw_dist, 1.0 - raw_dist);
	return dist;
}

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 final_color = texture(TEXTURE, UV);
	float diag_uv = fract(UV.x - UV.y);

	final_color.r += get_dist(0, diag_uv);
	final_color.g += get_dist(0.33f, diag_uv);
	final_color.b += get_dist(0.66f, diag_uv);

	COLOR = final_color;
}


