extends Node

signal removed_card
signal new_turn
signal end_round
signal reset_game
	
func signal_emitter(name : String):
	emit_signal(name)
