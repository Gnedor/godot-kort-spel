extends Node2D

var tile_database = preload("res://Scripts/tile_database.gd")
var tile_scene = load("res://Scenes/tile.tscn")
@onready var input_manager: Node2D = $"../InputManager"
@onready var folder: Node2D = $Folder
@onready var arrow: Sprite2D = $Folder/Button/arrow
@onready var button: Button = $Folder/Button

var menu_up : bool = true

var selected_deck
var owned_tiles = []
var tiles_in_folder = []
var played_tiles = []
var window_size : Vector2
var selected_slot

var dragged_tile : Node2D
var hovered_tile : Node2D

const FOLDER_BOUNDRY = 1792
const LABEL_MAX_SIZE = 280

const TILE_MOVE_SPEED = 4000 # pixels per second

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	window_size = get_viewport().size
	input_manager.tile_relesed_on_slot.connect(place_tile_on_slot)
	
	window_size = Vector2(1920, 1080)
	selected_deck = tile_database.EXAMPLE_DECK

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if dragged_tile:
		dragged_tile.global_position = Vector2(
			clamp(get_global_mouse_position().x, 0, window_size.x), 
			clamp(get_global_mouse_position().y, 0, window_size.y))
			#sätter de selectade kortet längst fram
		dragged_tile.z_index = owned_tiles.size() + 4
		sort_by_x_position(tiles_in_folder)

		
func sort_by_x_position(array: Array):
	array.sort_custom(compare_x_position)
	align_tiles()
	
# Function to compare two objects based on their x_position
func compare_x_position(a, b):
	if a.global_position.x < b.global_position.x:
		return true
	return false

func _on_button_pressed() -> void:
	if menu_up:
		animate_folder_down()
	else:
		animate_folder_up()
	
func animate_folder_down():
	if menu_up:
		arrow.rotation_degrees += 180
		var tween = get_tree().create_tween()
		tween.tween_property(folder, "global_position:y", position.y + 312, 0.2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		for tile in owned_tiles:
			if !tile.is_placed:
				tween.parallel() 
				tween.tween_property(tile, "global_position:y", position.y + 312, 0.2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		menu_up = false
			
func animate_folder_up():
	if !menu_up:
		arrow.rotation_degrees += 180
		var tween = get_tree().create_tween()
		tween.tween_property(folder, "global_position:y", position.y, 0.2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		for tile in owned_tiles:
			if !tile.is_placed:
				tween.parallel() 
				tween.tween_property(tile, "global_position:y", position.y, 0.2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		menu_up = true
	
func _on_button_button_up() -> void:
	arrow.position.y -= 3

func _on_button_button_down() -> void:
	arrow.position.y += 3
	
func align_tiles():
	var i = 0
	for tile in tiles_in_folder:
		if tile != dragged_tile and !tile.is_placed:
			var tile_pos_x = (window_size.x / 2) - (FOLDER_BOUNDRY / 2) + (FOLDER_BOUNDRY * (i + 1) / (tiles_in_folder.size() + 1))
			var new_pos = Vector2(tile_pos_x, folder.global_position.y)
			animate_tile_snap(tile, new_pos, TILE_MOVE_SPEED)
			tile.z_index = i + 1
		i += 1
		
func add_tiles_on_start():
	var tiles
	if Global.round == 1:
		tiles = tile_database.EXAMPLE_DECK
	else:
		tiles = Global.stored_tiles
	for tile in tiles:
		create_tile(tile)
	align_tiles()
		
func create_tile(tile_name: String):
	var new_tile_instance = tile_scene.instantiate()
	var tile_ability_script_path = tile_database.TILES[tile_name][1]
	new_tile_instance.ability_script = load(tile_ability_script_path).new()

	add_child(new_tile_instance)
	
	new_tile_instance.name_label.text = tile_name
	new_tile_instance.tile_type = tile_database.TILES[tile_name][2]
	new_tile_instance.tile_name = tile_name
	new_tile_instance.description_label.text = "[center]" + str(tile_database.TILES[tile_name][0]) + "[/center]"
	color_text(new_tile_instance.description_label)
	adjust_description_text(new_tile_instance.description_label)

	var image_path = "res://Assets/Images/Tiles/" + tile_name + "_tile.png"
	var texture = load(image_path)
	var sprite = new_tile_instance.get_node("Sprite2D")
	if sprite:
		sprite.texture = texture
	else:
		print("Sprite node not found in card instance")
		
	owned_tiles.append(new_tile_instance)
	tiles_in_folder.append(new_tile_instance)
	
func hover_effect(tile):
	tile.description.visible = true
	if !tile.is_placed:
		tile.scale = Vector2(1.1, 1.1)
	
func hover_off_effect(tile):
	tile.description.visible = false
	tile.scale = Vector2(1.0, 1.0)
	
func align_tile_hover(hovered_tile):
	for tile in owned_tiles:
		if tile == hovered_tile:
			hover_effect(tile)
		else:
			hover_off_effect(tile)
			
func animate_tile_snap(tile, position, speed):
	var tween = get_tree().create_tween()

	if tile.global_position.y != folder.global_position.y:
		tween.tween_property(tile, "global_position", position, find_duration(tile.global_position, position, speed * 2)).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	else:
		tween.tween_property(tile, "global_position", position, 0.2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	await tween.finished
	
func find_duration(pos1, pos2, speed):
	var distance = pos1.distance_to(pos2)
	var duration = distance / speed
	return duration
	
func place_tile_on_slot(slot):
	if !slot.occupied_tile:
		dragged_tile.z_index = -1
		dragged_tile.is_placed = true
		dragged_tile.global_position = slot.position
		
		tiles_in_folder.erase(dragged_tile)
		played_tiles.append(dragged_tile)
		slot.occupied_tile = dragged_tile
		
		dragged_tile = null
	align_tiles()
		
func adjust_description_text(label):
	label.custom_minimum_size = Vector2(LABEL_MAX_SIZE, 0)
	label.set_autowrap_mode(2)
	
	if label.get_line_count() <= 1:
		label.custom_minimum_size = Vector2(0, 0)
		label.set_autowrap_mode(0)
		
func color_text(label):
	var target_word = "Damage"
	var color = Color.html("#ac3232")
	var colored_word = "[color=" + color.to_html() + "]" + target_word + "[/color]"
	label.text = label.text.replace(target_word, colored_word)
	
	target_word = "Actions"
	color = Color.html("#639bff")
	colored_word = "[color=" + color.to_html() + "]" + target_word + "[/color]"
	label.text = label.text.replace(target_word, colored_word)
