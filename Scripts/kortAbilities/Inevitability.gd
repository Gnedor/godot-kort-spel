extends Node

var battle_manager_reference
var deck_reference

func _ready() -> void:
	var battle_scene = get_tree().get_root().find_child("BattleScene", true, false)
	battle_manager_reference = battle_scene.get_node("BattleManager")
	deck_reference = battle_scene.get_node("TroopDeck")

func trigger_ability(card):
	battle_manager_reference.ability_effect(card)
	var deck_size = deck_reference.cards_in_troop_deck.size()
	if deck_size > 0:
		var random_index1 = randi() % deck_size
		var	random_index2 = randi() % deck_size
		if deck_size > 1:
			while random_index2 == random_index1:
				random_index2 = randi() % deck_size
		deck_reference.replace_card_with_copy(deck_reference.cards_in_troop_deck[random_index1], card)
		deck_reference.replace_card_with_copy(deck_reference.cards_in_troop_deck[random_index2], card)
		
