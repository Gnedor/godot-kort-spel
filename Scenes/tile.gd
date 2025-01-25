extends Node2D

@onready var description: MarginContainer = $Description
@onready var name_label: Label = $Description/MarginContainer/NameLabel
@onready var description_label: RichTextLabel = $Description/MarginContainer/MarginContainer/DescriptionLabel

var tile_name : String
var ability_script
var is_placed : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
