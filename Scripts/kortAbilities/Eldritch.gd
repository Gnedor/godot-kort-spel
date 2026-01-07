extends Node

var card_manager_reference = BattleContext.card_manager
var battle_manager_reference = BattleContext.battle_manager
var rng = RandomNumberGenerator.new()

func trigger_ability(card):
	battle_manager_reference.ability_effect(card)
	var played_cards = card_manager_reference.played_cards
	var random_number = randi() % played_cards.size()
	
	var destroy_cards = [played_cards[random_number]]
	played_cards[random_number].is_selected = true
	card_manager_reference.discard_selected_cards(destroy_cards, "played")
	
