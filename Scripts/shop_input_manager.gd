extends Node2D

@onready var shop: Node2D = $".."

var hovered_card : Node2D

const CARD_MASK = 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var hovering_cards = raycast_check(CARD_MASK)
	if hovering_cards:
		var highest_card = check_for_highest_z_index(hovering_cards)
		hovered_card = highest_card
	else:
		hovered_card = null
		
	shop.hovered_card = hovered_card
	
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
