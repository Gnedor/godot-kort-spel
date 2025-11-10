shader_type canvas_item;

const float amount = 1.0;
const float speed = 2.0;

float rand(vec2 co) {
	return fract(sin(dot(co.xy, vec2(12.321, 67.242))) * 21984.2355);
}

void fragment() {
	vec4 texture_color = texture(TEXTURE, UV);
	vec4 color = texture_color;

	vec2 uv = UV;

	float t = floor(TIME * speed);
	float line_size = 0.05;
	float line_y = floor(uv.y / line_size) * line_size;

	float glitch_offset = (rand(vec2(t, line_y)) - 0.5) * 0.1 * amount;
	uv.x += glitch_offset;

	float adjustment_amount = amount / 10.0;
	color.r = texture(TEXTURE, vec2(uv.x + adjustment_amount, UV.y)).r;
	color.g = texture(TEXTURE, UV).g;
	color.b = texture(TEXTURE, vec2(uv.x + adjustment_amount, UV.y)).b;

	COLOR = color;
}

void vertex(){
	vec2 uv = UV;

	float t = floor(TIME * speed);
	float line_size = 0.05;
	float line_y = floor(uv.y / line_size) * line_size;

	float glitch_offset = (rand(vec2(t, line_y)) - 0.5) * 0.1 * amount;
	uv.x += glitch_offset;

	UV = uv;
}