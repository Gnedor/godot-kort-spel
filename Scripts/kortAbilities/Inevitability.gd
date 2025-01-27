extends Node


func trigger_ability(card, battle_manager_reference, deck_reference, card_manager_reference):
	battle_manager_reference.ability_effect(card)
	var deck_size = deck_reference.cards_in_troop_deck.size()
	if deck_size > 0:
		deck_size = deck_reference.cards_in_troop_deck.size()
		var random_index1 = randi() % deck_size
		var	random_index2 = randi() % deck_size
		if deck_size > 1:
			while random_index2 == random_index1:
				random_index2 = randi() % deck_size
		deck_reference.replace_card_with_copy(deck_reference.cards_in_troop_deck[random_index1], card)
		deck_reference.replace_card_with_copy(deck_reference.cards_in_troop_deck[random_index2], card)
		
