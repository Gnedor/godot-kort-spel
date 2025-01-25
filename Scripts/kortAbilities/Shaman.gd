extends Node

func trigger_ability(card, battle_manager_reference, deck_reference, card_manager_reference, selected_card):
	card.actions -= 1
	selected_card.attack += 2
	card_manager_reference.update_card(selected_card)
	card_manager_reference.update_card(card)
	await battle_manager_reference.ability_effect(card)
