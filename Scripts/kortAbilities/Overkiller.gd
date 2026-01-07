extends Node

var battle_manager_reference = BattleContext.battle_manager

func trigger_ability(card_reference):
	if Global.total_damage <= battle_manager_reference.damage:
		card_reference.actions += 1
		card_reference.turn_actions += 1
		card_reference.update_card()
