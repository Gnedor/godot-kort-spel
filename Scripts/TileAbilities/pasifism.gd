extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func tile_ability(card):
	card.silenced = true
	card.actions += 2
	card.turn_actions += 2
	card.update_card()
