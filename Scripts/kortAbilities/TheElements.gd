extends Node

var battle_manager_reference = BattleContext.battle_manager
var card_manager_reference = BattleContext.card_manager

func trigger_ability(card_reference):
	var cards = [card_reference]
	
	card_manager_reference.cards_in_hand.erase(card_reference)
	card_reference.is_selected = true
	card_reference.scale = Vector2(1.2, 1.2)
	card_reference.get_node("Area2D/CollisionShape2D").disabled = true
	
	focus_card()
	card_manager_reference.animate_card_snap(card_reference, Vector2(960, 200), 3000, 1)
	
	await Global.timer(0.5)
	
	var amount : int = 0
	for debuff in battle_manager_reference.debuffs.keys():
		if battle_manager_reference.debuffs[debuff] > 0:
			amount += 1
	
	card_manager_reference.draw_cards(amount, 0)
	await battle_manager_reference.ability_effect(card_reference)
	
	unfocus_card()
	
	card_manager_reference.discard_selected_cards(cards, "Hand")
	
func focus_card():
	battle_manager_reference.darken_background.z_index = card_manager_reference.cards_in_hand.size() + 3
	battle_manager_reference.darken_screen()
	
	card_manager_reference.deck.z_index = card_manager_reference.cards_in_hand.size() + 5
		
	for card in card_manager_reference.cards_in_hand:
		card.get_node("Area2D/CollisionShape2D").disabled = true
		
	battle_manager_reference.end_turn.disabled = true
	
func unfocus_card():
	battle_manager_reference.brighten_screen()
	
	card_manager_reference.deck.z_index = 0
		
	for card in card_manager_reference.cards_in_hand:
		card.get_node("Area2D/CollisionShape2D").disabled = false
		
	battle_manager_reference.end_turn.disabled = false
