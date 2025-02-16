extends Node

func trigger_ability(card_reference, battle_manager_reference, deck_reference, card_manager_reference):
	card_manager_reference.cards_in_hand.erase(card_reference)
	card_reference.is_selected = true
	var cards = [card_reference]
	card_manager_reference.discard_selected_cards(cards, "Hand")
