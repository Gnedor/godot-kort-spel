extends Node

func trigger_ability(card, _battle_manager_reference, _deck_reference, _card_manager_reference):
	var cards = [card]
	_card_manager_reference.cards_in_hand.erase(card)
	card.is_selected = true
	card.scale = Vector2(1.2, 1.2)
	card.get_node("Area2D/CollisionShape2D").disabled = true
	await _card_manager_reference.animate_card_snap(card, Vector2(960, 200), 3000, 1)
	_battle_manager_reference.enter_chose_deck(card, 2)
