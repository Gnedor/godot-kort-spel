extends Node

var card_manager_reference
var battle_manager_reference

func _ready() -> void:
	var battle_scene = get_tree().get_root().find_child("BattleScene", true, false)
	card_manager_reference = battle_scene.get_node("CardManager")
	battle_manager_reference = battle_scene.get_node("BattleManager")
	
func trigger_ability(card_reference):
	battle_manager_reference.ability_effect(card_reference)
	var index = get_card_index(card_reference)
	var affected_cards = find_bordering_cards(index)
	if affected_cards:
		for card in affected_cards:
			card.actions += 1
			card_manager_reference.update_card(card)
	

func get_card_index(card):
	for i in range(5):
		var card_slot = card_manager_reference.card_slots.get_node("CardSlot" + str(i + 1))
		if card_slot.position == card.position:
			return i
			
func find_bordering_cards(index):
	var returned_cards = [] 
	var card_slot = card_manager_reference.card_slots.get_node("CardSlot" + str(index + 2))
	for card in card_manager_reference.played_cards:
		if card_slot and card.position == card_slot.position:
			returned_cards.append(card)
	
	card_slot = card_manager_reference.card_slots.get_node("CardSlot" + str(index))
	for card in card_manager_reference.played_cards:
		if card_slot and card.position == card_slot.position:
			returned_cards.append(card)
	return returned_cards
