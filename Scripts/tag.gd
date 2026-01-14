extends Control
class_name Tag

signal on_hover
signal on_hover_off

func _on_area_2d_mouse_entered() -> void:
	scale = Vector2(1.2, 1.2)
	on_hover.emit(self)

func _on_area_2d_mouse_exited() -> void:
	scale = Vector2(1.0, 1.0)
	on_hover_off.emit()
	
func disable_collision(state : bool):
	$Area2D/CollisionShape2D.disabled = state
