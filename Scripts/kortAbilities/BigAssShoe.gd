extends Node


func trigger_ability(_card_reference, _battle_manager_reference, __deck_reference, __card_manager_reference):
	__card_manager_reference.cards_in_hand.erase(_card_reference)
	_card_reference.is_selected = true
	var cards = [_card_reference]
	__card_manager_reference.discard_selected_cards(cards, "Hand")
