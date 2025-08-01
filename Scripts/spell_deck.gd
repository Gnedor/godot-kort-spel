extends Node2D


func _on_area_2d_mouse_entered() -> void:
	$AnimationPlayer.play("grow")


func _on_area_2d_mouse_exited() -> void:
	$AnimationPlayer.play("shrink")
