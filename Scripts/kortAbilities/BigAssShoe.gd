extends Node

var card_slots_reference = BattleContext.card_slots
var card_manager_reference = BattleContext.card_manager
var battle_manager_reference = BattleContext.battle_manager
var deck_reference = BattleContext.deck

func trigger_ability(card_reference):
	card_manager_reference.cards_in_hand.erase(card_reference)
	card_reference.is_selected = true
	card_reference.scale = Vector2(1.2, 1.2)
	card_reference.get_node("Area2D/CollisionShape2D").disabled = true
	card_manager_reference.animate_card_snap(card_reference, Vector2(960, 200), 3000, 1)
	
	await Global.timer(0.3)
	
	for card in card_manager_reference.played_cards:
		card.is_selected = true
	await card_manager_reference.discard_selected_cards(card_manager_reference.played_cards, "played")
	
	for slot in card_slots_reference.get_children():
		if deck_reference.cards_in_troop_deck.size() > 0:
			var random_number = randi() % deck_reference.cards_in_troop_deck.size()
			var card = deck_reference.cards_in_troop_deck[random_number]
			
			card_manager_reference.cards_in_hand.append(card)
			card.visible = true
			card.adjust_text_size()
			card.get_node("Area2D/CollisionShape2D").disabled = false
			card.in_deck = false
			deck_reference.cards_in_troop_deck.remove_at(random_number)
			deck_reference.troop_deck_counter.text = str(deck_reference.cards_in_troop_deck.size())
			
			card_manager_reference.cards_in_hand.erase(card)
			
			await card_manager_reference.animate_card_snap(card, slot.global_position, 3000, 1)
			card_manager_reference.dragged_card = card
			card_manager_reference.place_card_on_slot(slot)
			card_manager_reference.dragged_card = null
		
	var cards = [card_reference]
	card_manager_reference.discard_selected_cards(cards, "Hand")
