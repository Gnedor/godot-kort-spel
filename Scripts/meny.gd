extends Node2D

var dialog = [
	"Hello kind stranger :)", 
	"That STEN needs a beating for some reason",
	"Gip gup gap gep gop gyp",
	"Don't be mean to dentists, they have fillings to",
	"I remember",
	"I pray for your downfall and untimely demise",
	"Bush did 7/11",
	"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAH",
	"What does the mango say?",
	"Mamamamamango Mamamamamango",
	"Sten is Stone in a funny language",
	"Fun fact: this game was made in under 1 minute",
	"This is the official STEN game",
	"I can actually do a handstand",
	"No text in this game is spell checked",
	"I posses greater knowledge than any mortal",
	"My tummy hurts",
	"I hate the Options guy",
	"This game began development in 1942",
	"I wish uppon you a great day",
	"Minceraft",
	"A battlepass will soon be added",
	"I'm in the progress of writing a book"
	]
signal on_scene_exit

var move_up
var move_down

var first_enter : bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func on_enter_scene():
	display_dialog()
	move_in_scene()
	
func display_dialog():
	var dialog_label = $PovGuy/ColorRect/Label
	dialog_label.visible_ratio = 0.0
	dialog_label.text = dialog.pick_random()
	await Global.timer(0.5)
	var tween = get_tree().create_tween()
	tween.tween_property(dialog_label, "visible_ratio", 1.0, 1)
	var text_length = 0
	AudioManager.animate_text_audio(str(dialog_label.get_text()).length(), 1)
	
func remove_scene():
	$Title/AnimationPlayer.stop()
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)

	for obj in move_up:
		tween.parallel().tween_property(obj, "position:y", obj.position.y - 700, 0.3)
		
	for obj in move_down:
		tween.parallel().tween_property(obj, "position:y", obj.position.y + 500, 0.3)
		
	await tween.finished
		
func move_in_scene():
	move_up = [$sten, $Title, $PovGuy]
	move_down = [$VBoxContainer]
	
	if first_enter:
		for obj in move_up:
			obj.position.y -= 700
		for obj in move_down:
			obj.position.y += 500
		first_enter = false
		
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	
	for obj in move_up:
		tween.parallel().tween_property(obj, "position:y", obj.position.y + 700, 0.3)
		
	for obj in move_down:
		tween.parallel().tween_property(obj, "position:y", obj.position.y - 500, 0.3)
		
	await tween.finished
	$Title/AnimationPlayer.play()
	
func _on_start_button_pressed() -> void:
	await remove_scene()
	Global.scene_name = "sten"
	on_scene_exit.emit()
