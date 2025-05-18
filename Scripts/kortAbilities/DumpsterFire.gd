extends Node

var card_manager_reference
var battle_manager_reference
var trashed_cards : int = 0

func _ready() -> void:
	var battle_scene = get_tree().get_root().find_child("BattleScene", true, false)
	card_manager_reference = battle_scene.get_node("CardManager")
	battle_manager_reference = battle_scene.get_node("BattleManager")
	SignalManager.removed_card.connect(add_mult)
	SignalManager.end_round.connect(remove_mult)
	
func add_mult():
	trashed_cards += 1
	if trashed_cards % 2 == 0:
		get_parent().round_mult *= 2
		get_parent().turn_mult *= 2
		get_parent().update_card()

func remove_mult():
	trashed_cards = 0
