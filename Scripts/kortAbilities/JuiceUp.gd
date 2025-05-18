extends Node

var battle_manager_reference
var card_manager_reference

func _ready() -> void:
	var battle_scene = get_tree().get_root().find_child("BattleScene", true, false)
	battle_manager_reference = battle_scene.get_node("BattleManager")
	card_manager_reference = battle_scene.get_node("CardManager")

func trigger_ability(card):
	battle_manager_reference.enter_chose_card(card)
	
func give_effect(card):
	card.turn_mult *= 2
	card.turn_attack -= 3
	card.base_attack -= 3
	card.update_card()
	
	
