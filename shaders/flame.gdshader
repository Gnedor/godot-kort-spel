shader_type canvas_item;

uniform float y_offset = 0.5;
uniform float animation_speed = 0.5;
uniform vec4 flame_color : source_color = vec4(1.0);
uniform vec4 secondary_flame_color : source_color = vec4(1.0);
uniform vec4 background_color : source_color = vec4(1.0);
uniform sampler2D noise_texture: hint_default_black, repeat_enable;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec2 uv = vec2(UV.x, UV.y + TIME * animation_speed);
	vec4 noise_color = texture(noise_texture, uv);
	vec4 final_color = noise_color;
	final_color.rgb += vec3(UV.y - y_offset);
	final_color.rgb -= vec3(1.0 - UV.y);

	//final_color.rgb = step(final_color.rgb, vec3(0.5));
	if (all(greaterThan(final_color.rgb, vec3(0.5)))){
		final_color.rgb = flame_color.rgb;
	}
	else{
		if (all(greaterThan(final_color.rgb, vec3(0.4)))){
			final_color.rgb = secondary_flame_color.rgb;
		}
		else{
			final_color.rgb = background_color.rgb;
		}
	}

	COLOR = final_color;
}
