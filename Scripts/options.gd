extends Control

var tween : Tween

signal exit_pause

func _ready() -> void:
	visible = false
	exit_pause_anim()

func _on_fullscreen_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		
func scale_window(option : Control, target_scale : Vector2):
	var base_min_size_x : int = 448
	#var base_min_size_y : int = 180
	var time : float = 0.3
	
	var options_list = option.get_node("OptionDesc/OptionList")
	
	var bright_effect = option.get_node("HoverEffect")
	var shade_effect = option.get_node("ShadeEffect")
	
	tween = get_tree().create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	for node in option.get_children():
		tween.parallel().tween_property(node, "scale", target_scale, time)
	
	if target_scale != Vector2(1.0, 1.0):
		tween.parallel().tween_property(option, "custom_minimum_size", Vector2(base_min_size_x * target_scale.x, options_list.get_size().y + 80), time)
		tween.parallel().tween_property(bright_effect, "color", Color(1.0, 1.0, 1.0, 0.1), time / 2)
		tween.parallel().tween_property(shade_effect, "modulate", Color(1.0, 1.0, 1.0, 0.0), time / 2)
	else:
		tween.parallel().tween_property(option, "custom_minimum_size", Vector2(base_min_size_x * target_scale.x, 180), time)
		tween.parallel().tween_property(bright_effect, "color", Color(1.0, 1.0, 1.0, 0.0), time / 2)
		tween.parallel().tween_property(shade_effect, "modulate", Color(1.0, 1.0, 1.0, 1.0), time / 2)


func _on_video_mouse_entered() -> void:
	scale_window(%Video, Vector2(1.2, 1.2))

func _on_video_mouse_exited() -> void:
	scale_window(%Video, Vector2(1.0, 1.0))


func _on_volume_mouse_entered() -> void:
	scale_window(%Volume, Vector2(1.2, 1.2))

func _on_volume_mouse_exited() -> void:
	scale_window(%Volume, Vector2(1.0, 1.0))


func _on_back_button_pressed() -> void:
	exit_pause.emit()

func _on_back_button_button_up() -> void:
	$NinePatchRect/BackButton/BackLabel.position.y -= 3

func _on_back_button_button_down() -> void:
	$NinePatchRect/BackButton/BackLabel.position.y += 3
	
	
func exit_pause_anim():
	$DarkBG.mouse_filter = 2
	tween = get_tree().create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property($DarkBG, "color", Color(0.0, 0.0, 0.0, 0.0), 0.1)
	tween.parallel().tween_property($CPUParticles2D, "modulate", Color(0.0, 0.0, 0.0, 0.0), 0.1)
	
	tween.parallel().tween_property($NinePatchRect, "modulate", Color(0.0, 0.0, 0.0, 0.0), 0.1)
	tween.parallel().tween_property($NinePatchRect, "scale", Vector2(0.9, 0.9), 0.1)
	await tween.finished
	visible = false
	
func enter_pause_anim():
	visible = true
	$DarkBG.mouse_filter = 0
	tween = get_tree().create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property($DarkBG, "color", Color(0.0, 0.0, 0.0, 0.765), 0.1)
	tween.parallel().tween_property($CPUParticles2D, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.1)
	
	tween.parallel().tween_property($NinePatchRect, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.1)
	tween.parallel().tween_property($NinePatchRect, "scale", Vector2(1.0, 1.0), 0.1)
	await tween.finished
