extends Node2D

@onready var card_manager: Node2D = $"../CardManager"
@onready var deck: Node2D = $"../TroopDeck"
@onready var battle_manager: Node2D = $"../BattleManager"
@onready var tiles_folder: Node2D = $"../TilesFolder"

signal card_relesed_on_slot
signal tile_relesed_on_slot
signal card_clicked_on_slot
signal click_on_sten
signal click_on_discard
signal trigger_ability
signal untrigger_ability
signal select_target_card
signal select_deck

const CARD_MASK = 2
const CARD_SLOT_MASK = 4
const DECK_MASK = 8
const STEN_MASK = 16
const DISCARD_MASK = 32
const SPELL_AREA_MASK = 64
const TILE_MASK = 128

var hovered_card : Node2D
var dragged_card : Node2D

var hovered_tile : Node2D
var dragged_tile : Node2D

var selected_slot : Node2D

func _process(delta: float) -> void:
	if raycast_check(CARD_MASK) and !card_manager.dragged_card and !dragged_tile:
		var highest_card = check_for_highest_z_index(raycast_check(CARD_MASK))
		hovered_card = highest_card
	else:
		hovered_card = null
		
	card_manager.align_card_hover(hovered_card)
	
	if raycast_check(TILE_MASK) and !tiles_folder.dragged_tile and !dragged_card:
		var highest_tile = check_for_highest_z_index(raycast_check(TILE_MASK))
		hovered_tile = highest_tile
	else:
		hovered_tile = null
		
	tiles_folder.align_tile_hover(hovered_tile)
	
# kollar vilket knapp som trycks
func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		# On Press
		if event.pressed:
			if hovered_card:
				card_manager.dragged_card = hovered_card
				dragged_card = hovered_card
				if battle_manager.active_select:
					battle_manager.selected_card = hovered_card
					select_target_card.emit()
				
			if raycast_check(CARD_SLOT_MASK) and hovered_card:
				card_clicked_on_slot.emit(hovered_card)
				
			if raycast_check(STEN_MASK):
				click_on_sten.emit(card_manager.played_cards)
				
			if raycast_check(DISCARD_MASK):
				click_on_discard.emit(card_manager.played_cards, "played")
				
			if raycast_check(DECK_MASK):
				if battle_manager.deck_select:
					select_deck.emit(raycast_check(DECK_MASK))
					
			if hovered_tile and !hovered_tile.is_placed:
				tiles_folder.dragged_tile = hovered_tile
				dragged_tile = hovered_tile
			
		# On Release
		else:
			var slot_result = raycast_check(CARD_SLOT_MASK)
			if slot_result:
				selected_slot = slot_result[0].collider.get_parent()
				if dragged_card:
					card_relesed_on_slot.emit(selected_slot)
				elif dragged_tile:
					tile_relesed_on_slot.emit(selected_slot)
			else:
				selected_slot = null
			# emittar signalen om musen släpps över en slot
				
			if dragged_card:
				if dragged_card.card_type == "Spell" and raycast_check(SPELL_AREA_MASK) and !battle_manager.deck_select:
					tiles_folder.animate_folder_up()
					card_manager.cards_in_hand.erase(dragged_card)
					dragged_card.ability_script.trigger_ability(dragged_card, battle_manager, deck, card_manager)
					dragged_card = null

			if card_manager.dragged_card:
				card_manager.dragged_card = null
				card_manager.align_cards()
				
			if tiles_folder.dragged_tile:
				tiles_folder.dragged_tile = null
				tiles_folder.align_tiles()
				
			dragged_card = null
			dragged_tile = null
				
		
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		if event.pressed:
			var card
			if raycast_check(CARD_MASK):
				card = check_for_highest_z_index(raycast_check(CARD_MASK))
			if card and raycast_check(CARD_SLOT_MASK):
				if card.is_selected:
					card_manager.deselect_effect(card)
					card.is_selected = false
			else:
				card_manager.deselect_all()

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
		
func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ENTER:
			card_manager.draw_cards(3, 0)
		elif event.pressed and event.keycode == KEY_SPACE:
			if !battle_manager.deck_select:
				if !battle_manager.active_select:
					trigger_ability.emit()
				else:
					untrigger_ability.emit()

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
