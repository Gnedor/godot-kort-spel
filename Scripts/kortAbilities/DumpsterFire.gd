extends Node

var trashed_cards : int = 0

func _ready() -> void:
	SignalManager.trashed_card.connect(add_mult)
	SignalManager.end_round.connect(remove_mult)
	
func add_mult():
	trashed_cards += 1
	if trashed_cards % 5 == 0:
		get_parent().round_mult *= 1.5
		get_parent().turn_mult *= 1.5
		get_parent().update_card()

func remove_mult():
	trashed_cards = 0
