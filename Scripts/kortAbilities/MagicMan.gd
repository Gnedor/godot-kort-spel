extends Node

func trigger_ability(card, _battle_manager_reference, _deck_reference, _card_manager_reference):
	_battle_manager_reference.ability_effect(card)
	_battle_manager_reference.throw_projectile_from_card("Ball", card, 0.2, 3)
