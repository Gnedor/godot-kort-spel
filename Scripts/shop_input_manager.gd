extends Node2D

@onready var shop: Node2D = $".."
@onready var card_manager_screen: Node2D = $"../CardCollection/CardManagerScreen"

var hovered_card : Node2D
var hovered_tile : Node2D

const CARD_MASK = 2
const TILE_MASK = 128
const COLLECTION_CARD_MASK = 256
const TAG_MASK = 512
const TAG_SLOT_MASK = 1024

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.scene_index == 0:
		match raycast_check():
			CARD_MASK:
				var highest_card = check_for_highest_z_index(raycast_check_mask(CARD_MASK))
				hovered_card = highest_card
					
			COLLECTION_CARD_MASK:
				var highest_card = check_for_highest_z_index(raycast_check_mask(COLLECTION_CARD_MASK))
				hovered_card = highest_card
				shop.hovered_card = highest_card
					
			TILE_MASK:
				var highest_tile = check_for_highest_z_index(raycast_check_mask(TILE_MASK))
				hovered_tile = highest_tile
			
			TAG_MASK:
				var hovered_tag = raycast_check_mask(TAG_MASK)
				shop.selected_card.tag_circle.visible = true
				if !card_manager_screen.dragged_tag and hovered_tag:
					card_manager_screen.hovered_tag = hovered_tag[0].collider.get_parent()

			
			TAG_SLOT_MASK:
				if card_manager_screen.dragged_tag:
					if raycast_check_mask(TAG_SLOT_MASK):
						card_manager_screen.dragged_tag.scale = Vector2(2.0, 2.0)
					else:
						card_manager_screen.dragged_tag.scale = Vector2(1.1, 1.1)
			
			_:
				hovered_card = null
				hovered_tile = null
				card_manager_screen.hovered_tag = null
				if shop.selected_card:
					shop.selected_card.tag_circle.visible = false
				
			
			
func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and Global.scene_index == 0:
		# On Press
		if event.pressed:
			if hovered_card and shop.viewing_collection:
				shop.select_card(hovered_card)
			if raycast_check_mask(TAG_MASK):
				var tag = raycast_check_mask(TAG_MASK)[0].collider.get_parent()
				card_manager_screen.offset = Vector2(
					(get_global_mouse_position().x - tag.global_position.x),
					(get_global_mouse_position().y - tag.global_position.y))
					
				card_manager_screen.stored_tag_pos = tag.position
				card_manager_screen.dragged_tag = tag
		else:
			if card_manager_screen.dragged_tag:
				card_manager_screen.align_tag()
				card_manager_screen.dragged_tag = null
				card_manager_screen.hovered_tag = null
		
	
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
	if shop.managing_card:
		parameters.collision_mask = TAG_MASK
	# Leave out collision_mask to detect everything
	var results = space_state.intersect_point(parameters)

	if results.size() > 0:
		var collider = results[0].collider
		if collider is Area2D:
			return collider.collision_layer  # This is the mask (layers the object is on)
	return null
		
func check_for_highest_z_index(cards):
	var card
	if cards:
		var highest_card = cards[0].collider.get_parent()
		for i in range(cards.size()):
			card = cards[i].collider.get_parent()
			if card.z_index > highest_card.z_index:
				highest_card = card
		return highest_card
	else:
		return null
		
func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_BACKSPACE:
			Global.total_money += 10
