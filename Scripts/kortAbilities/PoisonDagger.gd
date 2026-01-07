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
	
	if battle_manager_reference.debuffs["Poison"] > 0:
		battle_manager_reference.debuffs["Poison"] *= 2
	else:
		battle_manager_reference.create_debuff_icon("Poison")
		battle_manager_reference.debuffs["Poison"] = 5
		
	battle_manager_reference.update_labels()
	
	await battle_manager_reference.ability_effect(card_reference)
	unfocus_card()
	
	card_manager_reference.discard_selected_cards(cards, "Hand")
	
func focus_card():
	battle_manager_reference.darken_background.z_index = card_manager_reference.cards_in_hand.size() + 4
	battle_manager_reference.debuff_icons.z_index = card_manager_reference.cards_in_hand.size() + 4
	battle_manager_reference.debuff_text.z_index = card_manager_reference.cards_in_hand.size() + 4
	battle_manager_reference.darken_screen()
	
	for card in card_manager_reference.played_cards:
		card.z_index = card_manager_reference.cards_in_hand.size() + 5
		
	for card in card_manager_reference.cards_in_hand:
		card.get_node("Area2D/CollisionShape2D").disabled = true
		
	battle_manager_reference.end_turn.disabled = true
	
func unfocus_card():
	for card in card_manager_reference.played_cards:
		card.z_index = 2
		
	for card in card_manager_reference.cards_in_hand:
		card.get_node("Area2D/CollisionShape2D").disabled = false
		
	battle_manager_reference.end_turn.disabled = false
	
	await battle_manager_reference.brighten_screen()
	battle_manager_reference.debuff_icons.z_index = 1
	battle_manager_reference.debuff_text.z_index = 1
