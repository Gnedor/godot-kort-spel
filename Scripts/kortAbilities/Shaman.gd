extends Node

func trigger_ability(card, _battle_manager_reference, _deck_reference, _card_manager_reference, selected_card):
	card.actions -= 1
	selected_card.attack += 2
	_card_manager_reference.update_card(selected_card)
	_card_manager_reference.update_card(card)
	await _battle_manager_reference.ability_effect(card)
