extends Node

signal removed_card
signal trashed_card
signal new_turn
signal end_round
signal reset_game
	
# kan lägga in vad som hälst i extra t.ex SignalManager.signal_emitter("removed_card", "card": "guy", -||-)
# för att hämta extra variablen: 
func signal_emitter(name : String, extra = {}):
	emit_signal(name, extra)
		
