extends Node

var battle_manager_reference

func _ready() -> void:
	var battle_scene = get_tree().get_root().find_child("BattleScene", true, false)
	battle_manager_reference = battle_scene.get_node("BattleManager")

func trigger_ability(card, awdawd, dwad, dawdwad):
	battle_manager_reference.ability_effect(card)
	battle_manager_reference.throw_projectile_from_card("Ball", card, 0.2, 3)
