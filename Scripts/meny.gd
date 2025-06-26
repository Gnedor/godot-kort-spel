extends Node2D

var dialog = [
	"Hello kind stranger :)", 
	"That STEN needs a beating for some reason",
	"Gip gup gap gep gop gyp",
	"Don't be mean to dentist, they have fillings to",
	"I remember",
	"I pray for your downfall and untimely demise",
	"Bush did 7/11",
	"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAH",
	"What does the mango say?",
	"Mamamamamango Mamamamamango"]

signal on_scene_exit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func on_enter_scene():
	display_dialog()
	
func display_dialog():
	var dialog_label = $PovGuy/ColorRect/Label
	dialog_label.visible_ratio = 0.0
	dialog_label.text = dialog.pick_random()
	await Global.timer(0.5)
	var tween = get_tree().create_tween()
	tween.tween_property(dialog_label, "visible_ratio", 1.0, 1)
	
func remove_scene():
	var move_up = [$sten, $Title, $PovGuy]
	var move_down = [$OptionsButton, $ExitButton, $StartButton]
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)

	for obj in move_up:
		tween.parallel().tween_property(obj, "position:y", obj.position.y - 700, 0.3)
		
	for obj in move_down:
		tween.parallel().tween_property(obj, "position:y", obj.position.y + 500, 0.3)
		
	await tween.finished
		
	
func _on_start_button_pressed() -> void:
	await remove_scene()
	Global.scene_index = -1
	on_scene_exit.emit()
