extends Node

var battle_manager_reference = BattleContext.battle_manager

func trigger_ability(card):
	battle_manager_reference.enter_chose_card(card)
	
func give_effect(card):
	card.actions += 2
	card.animate_stat_change("action")
	card.update_card()
