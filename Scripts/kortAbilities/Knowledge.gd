extends Node

var battle_manager_reference = BattleContext.battle_manager
var card_manager_reference = BattleContext.card_manager

func trigger_ability(card):
	card_manager_reference.cards_in_hand.erase(card)
	card.is_selected = true
	card.scale = Vector2(1.2, 1.2)
	card.get_node("Area2D/CollisionShape2D").disabled = true
	await card_manager_reference.animate_card_snap(card, Vector2(960, 200), 3000, 1)
	battle_manager_reference.enter_chose_deck(card, 2)
