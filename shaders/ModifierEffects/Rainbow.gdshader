shader_type canvas_item;

uniform float speed = 0.5;

uniform float multiplier = 1.5;

float get_dist(float delay, float uv){
    float target = 1.0 - fract(TIME * speed + delay);
    float raw_dist = abs(uv - target);
    return min(raw_dist, 1.0 - raw_dist);
}

void fragment() {
    // Sample the texture normally
    vec4 tex = texture(TEXTURE, UV);

    // Convert it to grayscale
    float gray = dot(tex.rgb, vec3(0.2, 0.2, 0.2));
    vec3 base = vec3(gray);

    // Compute rainbow
    float diag_uv = fract(UV.x - UV.y);
    vec3 rainbow = vec3(
        get_dist(0.0, diag_uv) * multiplier,
        get_dist(0.33, diag_uv) * multiplier,
        get_dist(0.66, diag_uv) * multiplier
    );

    // Add rainbow on TOP of grayscale
    vec3 final_rgb = base + rainbow;

    COLOR = vec4(final_rgb, tex.a);
}