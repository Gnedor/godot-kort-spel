extends Node

func trigger_ability(_card_reference, _battle_manager_reference, _deck_reference, _card_manager_reference):
	var added_attack : int = 0
	_battle_manager_reference.ability_effect(_card_reference)
	
	for card in _card_manager_reference.played_cards:
		var original_attack = card.attack
		card.attack /= 2
		added_attack += (original_attack - card.attack)
		if card.turn_attack > card.attack:
			card.turn_attack = card.attack
		_card_manager_reference.update_card(card)
		
	_card_reference.attack += added_attack
	_card_reference.turn_attack = _card_reference.attack
	_card_manager_reference.update_card(_card_reference)
		
