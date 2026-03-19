extends Node2D

@onready var shop: Node2D = $".."
@onready var shop_scene_manager: Node2D = $"../ShopSceneManager"

var hovered_card : Node2D = null
var hovered_tile : Node2D = null

const CARD_MASK = 2
const DECK_MASK = 8
const TILE_MASK = 128

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.scene_name != "shop":
		return
		
	var hits = raycast_check()
	if !hits or Global.is_game_paused:
		shop.hover_off_card(hovered_card)
		shop.hover_off_tile(hovered_tile)
		return
		
	for node in hits:
		match node.collider.collision_layer:
			CARD_MASK:
				var new_hovered_card = node.collider.get_parent()
				if hovered_card:
					if hovered_card != new_hovered_card:
						shop.hover_off_card(hovered_card)
						shop.hover_card(new_hovered_card)

				hovered_card = new_hovered_card
				shop.hover_card(hovered_card)
					
			TILE_MASK:
				var new_hovered_tile = node.collider.get_parent()
				if hovered_tile:
					if hovered_tile != new_hovered_tile:
						shop.hover_off_tile(hovered_tile)
						shop.hover_tile(new_hovered_tile)

				hovered_tile = new_hovered_tile
				shop.hover_tile(hovered_tile)
			
func _input(event):
	if !(event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and Global.scene_name == "shop" and !Global.is_game_paused):
		return
	if !event.pressed:
		return
		
	var hits = raycast_check()
	if !hits:
		return
		
	for node in hits:
		match node.collider.collision_layer:
			DECK_MASK:
				shop_scene_manager.enter_collection()
		
func raycast_check_mask(mask : int):
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = mask
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result
	else:
		return null
		
func raycast_check():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	var results = space_state.intersect_point(parameters, 32)
	if results.size() > 0:
		return(results)
	return null
		
func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_BACKSPACE:
			Global.total_money += 10
	


func _on_back_button_pressed() -> void:
	shop_scene_manager.exit_collection()
