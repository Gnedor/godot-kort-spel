extends Node2D

@onready var damage_label: Label = $Damage/Damage2/DamageLabel
@onready var money_label: Label = $Money/Money2/MoneyLabel
@onready var round_label: Label = $Round/Round2/RoundLabel
@onready var card_label: Label = $FavoriteCard/Rect2/CardLabel

@onready var restart_label: Label = $RestartButton/RestartLabel
@onready var menu_label: Label = $MenuButton/MenuLabel

func _ready() -> void:
	get_parent().on_scene_enter.connect(on_enter)
	#damage_label.text = str(Global.highest_damage)
	#money_label.text = str(Global.highest_money) + "$"
	#round_label.text = str(Global.round)
	#if Global.find_common_card():
		#card_label.text = Global.find_common_card()
	#else:
		#card_label.text = "None"

func on_enter():
	damage_label.text = str(Global.highest_damage)
	money_label.text = str(Global.highest_money) + "$"
	round_label.text = str(Global.round)
	if Global.find_common_card():
		card_label.text = Global.find_common_card()
	else:
		card_label.text = "None"
		
func _on_restart_button_button_down() -> void:
	restart_label.position.y += 3

func _on_restart_button_button_up() -> void:
	restart_label.position.y -= 3

func _on_restart_button_pressed() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position:y", -700, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	
	Global.reset_game()
	Global.scene_index = 0
	get_parent().on_scene_exit.emit()
	#get_tree().change_scene_to_file("res://Scenes/main.tscn")


func _on_menu_button_button_down() -> void:
	menu_label.position.y += 3

func _on_menu_button_button_up() -> void:
	menu_label.position.y -= 3

func _on_menu_button_pressed() -> void:
	Global.reset_game()
	get_tree().change_scene_to_file("res://Scenes/start_menu.tscn")
