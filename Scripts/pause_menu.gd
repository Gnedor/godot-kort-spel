extends Control

var tween : Tween
var big_scale : float = 1.3

func scale_button(button : Button, target_scale : Vector2):
	var time : float = 0.5
	var scale_difference : float = 0.5
	var fixed_time_ratio : float = 1
	var base_min_size_x : int = 256
	var base_min_size_y : int = 128
	
	if button.scale != Vector2(1.0, 1.0):
		if target_scale != Vector2(1.0, 1.0):
			fixed_time_ratio = 1 - ((button.scale.x - 1) / scale_difference)
		else:
			(button.scale.x - 1) / scale_difference
	
	tween = get_tree().create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(button, "custom_minimum_size", Vector2(base_min_size_x * target_scale.x, base_min_size_y * target_scale.y), time * fixed_time_ratio)


func _on_exit_button_mouse_entered() -> void:
	scale_button(%ExitButton, Vector2(big_scale, big_scale))

func _on_exit_button_mouse_exited() -> void:
	scale_button(%ExitButton, Vector2(1.0, 1.0))
	

func _on_options_button_mouse_entered() -> void:
	scale_button(%OptionsButton, Vector2(big_scale, big_scale))

func _on_options_button_mouse_exited() -> void:
	scale_button(%OptionsButton, Vector2(1.0, 1.0))


func _on_back_button_mouse_entered() -> void:
	scale_button(%BackButton, Vector2(big_scale, big_scale))

func _on_back_button_mouse_exited() -> void:
	scale_button(%BackButton, Vector2(1.0, 1.0))
