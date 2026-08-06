extends Node2D

func _on_area_2d_mouse_entered() -> void:
	scale = Vector2(3.3, 3.3)

func _on_area_2d_mouse_exited() -> void:
	scale = Vector2(3, 3)
