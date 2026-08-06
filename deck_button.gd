extends Control

@onready var deck_image: TextureRect = $DeckImage

const CARD_COLLECTION = preload("res://Scenes/card_collection.tscn")

var hover : bool = false
var camera : Camera2D

func _ready() -> void:
	camera = get_tree().get_current_scene().get_node("Camera2D")

func _on_texture_rect_mouse_entered() -> void:
	deck_image.scale = Vector2(3.3, 3.3)
	hover = true

func _on_texture_rect_mouse_exited() -> void:
	deck_image.scale = Vector2(3, 3)
	hover = false
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and !Global.is_game_paused:
		if event.pressed and hover:
			on_click()

func on_click():
	var collection = CARD_COLLECTION.instantiate()
	collection.position.y = camera.get_position().y + 1080
	move_in_collection(collection)
	
func move_in_collection(collection):
	collection.move_in_cards()
	camera.view_collection()
	

	
	
	
	
