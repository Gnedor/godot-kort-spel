extends Node

signal removed_card
signal trashed_card
signal new_turn
signal end_round
signal reset_game
signal shake_camera
signal reset_stage
signal return_menu
signal exit_game
signal reset_current_scene

# kan lägga in vad som hälst i extra t.ex SignalManager.signal_emitter("removed_card", "card": "guy", -||-)
# för att hämta extra variablen: 
func signal_emitter(name : String, extra = null):
	if extra != null:
		emit_signal(name, extra)
	else:
		emit_signal(name)

		
