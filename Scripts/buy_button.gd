extends Node2D
@onready var label: Label = $MarginContainer/MarginContainer/Label
@onready var button: Button = $MarginContainer/Button

signal buy_button_pressed
	
func _on_button_button_down() -> void:
	label.position.y += 2

func _on_button_button_up() -> void:
	label.position.y -= 2

func _on_button_pressed() -> void:
	buy_button_pressed.emit(get_parent())
