extends CanvasLayer

signal loading_screen_ready

@export var animation_player : AnimationPlayer

func _ready() -> void:
	await animation_player.animation_finished
	loading_screen_ready.emit()
	
func _on_progress_changed(new_value: float):
	pass
	
func _on_load_finished():
	animation_player.play_backwards("fade_in")
	await animation_player.animation_finished
	queue_free()
