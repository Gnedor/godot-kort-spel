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
	
func set_details(tile_name : String):
	var tile_ability_script_path = TileDatabase.TILES[tile_name][1]
	var new_ability_script = load(tile_ability_script_path).new()
	ability_script = new_ability_script
	#add_child(ability_script)
	
	name_label.text = tile_name
	tile_type = TileDatabase.TILES[tile_name][2]
	tile_name = tile_name
	description_label.text = "[center]" + str(TileDatabase.TILES[tile_name][0]) + "[/center]"
	Global.color_text(description_label)
	adjust_description_text(description_label)

	var image_path = "res://Assets/images/Tiles/" + tile_name + "_tile.png"
	var texture = load(image_path)
	var sprite = get_node("Sprite2D")
	if sprite:
		sprite.texture = texture
	else:
		print("Sprite node not found in tile instance")
		
func adjust_description_text(label):
	if label.get_line_count() <= 1:
		label.custom_minimum_size = Vector2(0, 0)
		label.set_autowrap_mode(0)
