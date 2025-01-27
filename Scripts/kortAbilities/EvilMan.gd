extends Node


func trigger_ability(card_reference, battle_manager_reference, deck_reference, card_manager_reference):
	var added_attack : int = 0
	battle_manager_reference.ability_effect(card_reference)
	
	for card in card_manager_reference.played_cards:
		var original_attack = card.attack
		card.attack /= 2
		added_attack += (original_attack - card.attack)
		if card.turn_attack > card.attack:
			card.turn_attack = card.attack
		card_manager_reference.update_card(card)
		
	card_reference.attack += added_attack
	card_reference.turn_attack = card_reference.attack
	card_manager_reference.update_card(card_reference)
		
		
