extends Node

func trigger_ability(_card_reference, _battle_manager_reference, _deck_reference, _card_manager_reference):
	_battle_manager_reference.ability_effect(_card_reference)
	var index = get_card_index(_card_reference, _card_manager_reference)
	var affected_cards = find_bordering_cards(index, _card_manager_reference)
	if affected_cards:
		for card in affected_cards:
			card.actions += 1
			_card_manager_reference.update_card(card)
	

func get_card_index(card, _card_manager_reference):
	for i in range(5):
		var card_slot = _card_manager_reference.card_slots.get_node("CardSlot" + str(i + 1))
		if card_slot.position == card.position:
			return i
			
func find_bordering_cards(index, _card_manager_reference):
	var returned_cards = [] 
	var card_slot = _card_manager_reference.card_slots.get_node("CardSlot" + str(index + 2))
	for card in _card_manager_reference.played_cards:
		if card_slot and card.position == card_slot.position:
			returned_cards.append(card)
	
	card_slot = _card_manager_reference.card_slots.get_node("CardSlot" + str(index))
	for card in _card_manager_reference.played_cards:
		if card_slot and card.position == card_slot.position:
			returned_cards.append(card)
	return returned_cards
