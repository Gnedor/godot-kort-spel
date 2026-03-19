extends Node2D

@onready var description: MarginContainer = $Description
@onready var name_label: Label = $Description/MarginContainer/NameLabel
@onready var description_label: RichTextLabel = $Description/MarginContainer/MarginContainer/DescriptionLabel

var tile_name : String
var tile_type : String
var ability_script
var is_placed : bool = false
var price : int 

func hover_effect():
	if !is_placed:
		scale = Vector2(1.1, 1.1)
	description.visible = true
	
func hover_off_effect():
	scale = Vector2(1.0, 1.0)
	description.visible = false
