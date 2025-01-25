shader_type canvas_item;

uniform float invert_strength : hint_range(0.0, 1.0) = 0.0;

void fragment() {
    vec4 color = texture(TEXTURE, UV);
    color.rgb = mix(color.rgb, vec3(1.0) - color.rgb, invert_strength);
    COLOR = color;
}
