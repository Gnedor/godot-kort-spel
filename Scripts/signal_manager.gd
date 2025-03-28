extends Node

signal removed_card
	
func signal_emitter(name : String):
	emit_signal(name)
