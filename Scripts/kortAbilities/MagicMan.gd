extends Node

func trigger_ability(card, battle_manager_reference, deck_reference, card_manager_reference):
	card_manager_reference.dragged_card = null
	battle_manager_reference.ability_effect(card)
	battle_manager_reference.throw_projectile_from_card("Ball",card, 0.2, 3)
