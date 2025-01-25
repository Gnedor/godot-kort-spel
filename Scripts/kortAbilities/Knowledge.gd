extends Node

func trigger_ability(card, battle_manager_reference, deck_reference, card_manager_reference):
	var cards = [card]
	card_manager_reference.cards_in_hand.erase(card)
	card.is_selected = true
	card.scale = Vector2(1.2, 1.2)
	card.get_node("Area2D/CollisionShape2D").disabled = true
	await card_manager_reference.animate_card_snap(card, Vector2(960, 200), 3000)
	battle_manager_reference.enter_chose_deck(card, 2)
