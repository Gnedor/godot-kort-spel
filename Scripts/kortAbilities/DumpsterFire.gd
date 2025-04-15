extends Node

var card_manager_reference
var battle_manager_reference

func _ready() -> void:
	var battle_scene = get_tree().get_root().find_child("BattleScene", true, false)
	card_manager_reference = battle_scene.get_node("CardManager")
	battle_manager_reference = battle_scene.get_node("BattleManager")

func trigger_ability(card):
	var trashed_cards = card_manager_reference.discarded_cards.size()
	print(trashed_cards)
	for i in floor(trashed_cards / 2):
		card.multiplier *= 1.5
