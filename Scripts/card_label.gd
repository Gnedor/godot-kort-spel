extends NinePatchRect

signal label_hovered
signal label_hovered_off

func _on_area_2d_mouse_entered() -> void:
	label_hovered.emit(name)
	self_modulate = Color(0.184, 0.184, 0.184)
	scale = Vector2(1.02, 1.02)

func _on_area_2d_mouse_exited() -> void:
	label_hovered_off.emit()
	self_modulate = Color(0.128, 0.128, 0.128)
	scale = Vector2(1.0, 1.0)
	
