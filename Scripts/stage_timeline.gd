extends Control

var brightnes_decrease : float = 0.4
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	adjust_timeline()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func next_stage():
	animation_player.play("next_stage")
	
	var tween = get_tree().create_tween()
	var position = -1
	
	for child in $TextureRect/HBoxContainer.get_children():
		var pos_value = abs(position - 2)
		var v_value = 1 - (brightnes_decrease * pos_value)
		tween.parallel().tween_property(child, "modulate", Color.from_hsv(0, 0, v_value, 1.0), 0.5)
		tween.parallel().tween_property(child, "custom_minimum_size:x", 60 - (15 * pos_value), 0.5)
		position += 1
	
func adjust_timeline():
	animation_player.play("RESET")
	var stage_list = get_stage_list()
	var position = 0
	for child in $TextureRect/HBoxContainer.get_children():
		var pos_value = abs(position - 2)
		var v_value = 1 - (brightnes_decrease * pos_value)
		child.modulate = Color.from_hsv(0, 0, v_value, 1.0)
		child.custom_minimum_size.x = 60 - (15 * pos_value)
	
		var texture = load("res://Assets/images/StageIcons/" + stage_list[position] + "_icon.png")
		child.texture = texture
		
		position += 1

# Adjusta så att listn är flyttad några steg så att animationen blir rätt
func get_stage_list():
	var new_list = Global.stage_list.duplicate(true)
	for i in range(4):
		new_list.push_back(new_list.pop_front())
	if Global.round == 1:
		new_list[0] = "null"
		new_list[1] = "null"

	return new_list
