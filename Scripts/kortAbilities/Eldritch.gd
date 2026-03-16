extends Node

var card_manager_reference = BattleContext.card_manager
var battle_manager_reference = BattleContext.battle_manager
var rng = RandomNumberGenerator.new()

func trigger_ability(card):
	battle_manager_reference.ability_effect(card)
	var played_cards = card_manager_reference.played_cards
	var random_number = randi() % played_cards.size()
	
	var destroyed_card = played_cards[random_number]
	card_manager_reference.discard_card(destroyed_card)
	
