shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float color = (COLOR.r + COLOR.g + COLOR.b) / 3.0;
	COLOR = vec4(color, color, color, COLOR.a);

	COLOR.b -= 0.3;
	COLOR.rg += 0.5;
}
