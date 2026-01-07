extends Node

var battle_manager_reference = BattleContext.battle_manager

func trigger_ability(card):
	battle_manager_reference.ability_effect(card)
	battle_manager_reference.throw_projectile_from_card("Ball", card, 0.2, 3)
