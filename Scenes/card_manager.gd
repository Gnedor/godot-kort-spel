extends Node2D

signal back_pressed
signal trash_pressed

var selected_card

func _on_back_pressed() -> void:
	back_pressed.emit(selected_card)


func _on_trash_button_pressed() -> void:
	trash_pressed.emit(selected_card)
