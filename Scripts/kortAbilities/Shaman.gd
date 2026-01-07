extends Node

var battle_manager_reference = BattleContext.battle_manager

func trigger_ability(card, selected_card):
	card.actions -= 1
	selected_card.attack += 2
	selected_card.update_card()
	card.update_card()
	await battle_manager_reference.ability_effect(card)
