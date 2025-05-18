extends Node

signal removed_card
signal new_turn
signal end_round
	
func signal_emitter(name : String):
	emit_signal(name)
