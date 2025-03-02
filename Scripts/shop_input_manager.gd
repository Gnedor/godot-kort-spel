extends Node2D

@onready var shop: Node2D = $".."

var hovered_card : Node2D
var hovered_tile : Node2D

const CARD_MASK = 2
const TILE_MASK = 128

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.scene_index == 0:
		var hovering_cards = raycast_check(CARD_MASK)
		if hovering_cards:
			var highest_card = check_for_highest_z_index(hovering_cards)
			hovered_card = highest_card
		else:
			hovered_card = null
			
		var hovering_tiles = raycast_check(TILE_MASK)
		if hovering_tiles:
			var highest_tile = check_for_highest_z_index(hovering_tiles)
			hovered_tile = highest_tile
		else:
			hovered_tile = null
	
func raycast_check(mask : int):
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = mask
	var result = space_state.intersect_point(parameters)
	# om den hittar kort returnerar den parent Noden
	if result.size() > 0:
		return result
	else:
		return null
		
func check_for_highest_z_index(cards):
	var card
	if cards:
		var highest_card = cards[0].collider.get_parent()
		for i in cards.size():
			card = cards[i].collider.get_parent()
			if card.z_index > highest_card.z_index:
				highest_card = card
		return highest_card
	else:
		return
		
func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_BACKSPACE:
			Global.total_money += 10
