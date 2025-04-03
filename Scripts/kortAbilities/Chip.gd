extends Node

var card_manager_reference

func _ready() -> void:
	var battle_scene = get_tree().get_root().find_child("BattleScene", true, false)
	card_manager_reference = battle_scene.get_node("CardManager")

func trigger_ability(card_reference):
	card_manager_reference.cards_in_hand.erase(card_reference)
	card_reference.is_selected = true
	var cards = [card_reference]
	card_manager_reference.discard_selected_cards(cards, "Hand")
