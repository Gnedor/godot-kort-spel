extends Node

var battle_manager_reference
var card_manager_reference

func _ready() -> void:
	var battle_scene = get_tree().get_root().find_child("BattleScene", true, false)
	battle_manager_reference = battle_scene.get_node("BattleManager")
	card_manager_reference = battle_scene.get_node("CardManager")

func trigger_ability(card, selected_card):
	card.actions -= 1
	selected_card.attack += 2
	selected_card.update_card()
	card.update_card()
	await battle_manager_reference.ability_effect(card)
