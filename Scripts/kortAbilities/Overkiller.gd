extends Node


var battle_manager_reference
var card_manager_reference

func _ready() -> void:
	var battle_scene = get_tree().get_root().find_child("BattleScene", true, false)
	battle_manager_reference = battle_scene.get_node("BattleManager")
	card_manager_reference = battle_scene.get_node("CardManager")

func trigger_ability(card_reference):
	if Global.total_damage <= battle_manager_reference.damage:
		card_reference.actions += 1
		card_reference.turn_actions += 1
		card_reference.update_card()
