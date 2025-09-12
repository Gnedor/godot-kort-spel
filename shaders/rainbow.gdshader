shader_type canvas_item;

uniform float speed;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 final_color = texture(TEXTURE, UV);
	float target_1 = 1.0f - fract(TIME);
	float raw_dist = abs(UV.x - target_1);
	float dist = min(raw_dist, 1.0 - raw_dist);
	final_color.r += dist;
	
	float target_2 = 1.0f - fract(TIME + 0.33f);
	raw_dist = abs(UV.x - target_2);
	dist = min(raw_dist, 1.0 - raw_dist);
	final_color.b += dist;
	
	float target_3 = 1.0f - fract(TIME + 0.66f);
	raw_dist = abs(UV.x - target_3);
	dist = min(raw_dist, 1.0 - raw_dist);
	final_color.g += dist;
	
	COLOR = final_color;
}
