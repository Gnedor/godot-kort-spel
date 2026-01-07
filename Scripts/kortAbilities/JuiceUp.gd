extends Node

var battle_manager_reference = BattleContext.battle_manager

func trigger_ability(card):
	battle_manager_reference.enter_chose_card(card)
	
func give_effect(card):
	card.turn_mult *= 2
	card.turn_attack -= 3
	card.base_attack -= 3
	card.update_card()
	
	
