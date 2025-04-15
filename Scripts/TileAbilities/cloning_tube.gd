extends Node

var battle_manager_reference
var card_manager_reference
var deck_reference

func _ready() -> void:
	var battle_scene = get_tree().get_root().find_child("BattleScene", true, false)
	battle_manager_reference = battle_scene.get_node("BattleManager")
	card_manager_reference = battle_scene.get_node("CardManager")
	deck_reference = battle_scene.get_node("TroopDeck")

func tile_ability(card):
	if deck_reference.cards_in_troop_deck.size() > 0:
		var random = randi() % deck_reference.cards_in_troop_deck.size()
		deck_reference.replace_card_with_copy(deck_reference.cards_in_troop_deck[random], card)
