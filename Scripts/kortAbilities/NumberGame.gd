extends Node

var battle_manager_reference
var card_manager_reference

func _ready() -> void:
	var battle_scene = get_tree().get_root().find_child("BattleScene", true, false)
	battle_manager_reference = battle_scene.get_node("BattleManager")
	card_manager_reference = battle_scene.get_node("CardManager")

func trigger_ability(card_reference):
	var cards = [card_reference]
	
	card_manager_reference.cards_in_hand.erase(card_reference)
	card_reference.is_selected = true
	card_reference.scale = Vector2(1.2, 1.2)
	card_reference.get_node("Area2D/CollisionShape2D").disabled = true
	
	focus_card(battle_manager_reference, card_manager_reference)
	card_manager_reference.animate_card_snap(card_reference, Vector2(960, 200), 3000, 1)
	
	await Global.timer(0.5)
	
	var random_number = randi() % 2
	if random_number == 0:
		for card in card_manager_reference.played_cards:
			card.turn_attack += 2
			card.attack += 2
			card_manager_reference.update_card(card)
	else:
		for card in card_manager_reference.played_cards:
			card.turn_attack -= 2
			card.attack -= 2
			if card.attack < 0:
				card.attack = 0
			if card.turn_attack < 0:
				card.turn_attack = 0
			card_manager_reference.update_card(card)
			
	await battle_manager_reference.ability_effect(card_reference)
	unfocus_card(battle_manager_reference, card_manager_reference)
	
	card_manager_reference.discard_selected_cards(cards, "Hand")
	
func focus_card(_battle_manager_reference, _card_manager_reference):
	_battle_manager_reference.darken_background.z_index = _card_manager_reference.cards_in_hand.size() + 4
	_battle_manager_reference.darken_screen()
	
	for card in _card_manager_reference.played_cards:
		card.z_index = _card_manager_reference.cards_in_hand.size() + 5
		
	for card in _card_manager_reference.cards_in_hand:
		card.get_node("Area2D/CollisionShape2D").disabled = true
		
	_battle_manager_reference.end_turn.disabled = true
	
func unfocus_card(_battle_manager_reference, _card_manager_reference):
	_battle_manager_reference.brighten_screen()
	
	for card in _card_manager_reference.played_cards:
		card.z_index = 2
		
	for card in _card_manager_reference.cards_in_hand:
		card.get_node("Area2D/CollisionShape2D").disabled = false
		
	battle_manager_reference.end_turn.disabled = false
