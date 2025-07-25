extends Node2D

@onready var shop: Node2D = $".."
@onready var card_manager_screen: Node2D = $"../CardCollection/CardManagerScreen"

var hovered_card : Node2D
var hovered_tile : Node2D
var hovering_tag_slot : bool = false

const CARD_MASK = 2
const TILE_MASK = 128
const COLLECTION_CARD_MASK = 256
const TAG_MASK = 512
const TAG_SLOT_MASK = 1024

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.scene_index == 0:
		var hits = raycast_check()
		if hits and !Global.is_game_paused:
			var dragged_tag = card_manager_screen.dragged_tag
			for node in hits:
				match node.collider.collision_layer:
					CARD_MASK:
						hovered_card = node.collider.get_parent()
						shop.hovered_card = hovered_card
							
					COLLECTION_CARD_MASK:
						hovered_card = node.collider.get_parent()
						shop.hovered_card = hovered_card
							
					TILE_MASK:
						hovered_tile = node.collider.get_parent()
						shop.hovered_tile = hovered_tile
					
					TAG_MASK:
						if !shop.selected_card.tag:
							shop.selected_card.tag_circle.visible = true
						if !dragged_tag:
							card_manager_screen.hovered_tag = node.collider.get_parent()
							card_manager_screen.display_tag_description()
							
					TAG_SLOT_MASK:
						if dragged_tag and !shop.selected_card.tag:
							hovering_tag_slot = true
							
			if dragged_tag:
				if hovering_tag_slot:
					dragged_tag.scale = Vector2(1.5, 1.5)
				else:
					dragged_tag.scale = Vector2(1.1, 1.1)
				hovering_tag_slot = false
		else:
			hovered_card = null
			shop.hovered_card = null
			hovered_tile = null
			shop.hovered_tile = null
			if !card_manager_screen.dragged_tag:
				card_manager_screen.hovered_tag = null
				card_manager_screen.tag_description.visible = false
			if shop.selected_card:
				shop.selected_card.tag_circle.visible = false
			
			
func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and Global.scene_index == 0 and !Global.is_game_paused:
		var hits = raycast_check()
		if hits:
			for node in hits:
				if event.pressed:
					match node.collider.collision_layer:
						
						COLLECTION_CARD_MASK:
							if hovered_card and shop.viewing_collection:
								shop.select_card(node.collider.get_parent())
						
						TAG_MASK:
							var tag = node.collider.get_parent()
							shop.selected_card.tag_circle_collider.disabled = false
							card_manager_screen.offset = Vector2(
								(get_global_mouse_position().x - tag.global_position.x),
								(get_global_mouse_position().y - tag.global_position.y))
								
							card_manager_screen.stored_tag_pos = tag.position
							card_manager_screen.dragged_tag = tag
							card_manager_screen.hovered_tag = tag
							
				else:
					match node.collider.collision_layer:
						
						TAG_SLOT_MASK:
							if !shop.selected_card.tag:
								shop.selected_card.tag = card_manager_screen.dragged_tag.name
								shop.selected_card.place_tag(card_manager_screen.dragged_tag.name)
								card_manager_screen.dragged_tag.visible = false
								card_manager_screen.dragged_tag.get_node("Area2D/CollisionShape2D").disabled = true
								Global.stored_tags.erase(String(card_manager_screen.dragged_tag.name))
								card_manager_screen.dragged_tag = null
								
					if card_manager_screen.dragged_tag:
						card_manager_screen.align_tag()
						
					if shop.selected_card:
						shop.selected_card.tag_circle_collider.disabled = true
						#card_manager_screen.dragged_tag = null
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
	var results = space_state.intersect_point(parameters, 32)
	if results.size() > 0:
		return(results)
	return null
		
func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_BACKSPACE:
			Global.total_money += 10
