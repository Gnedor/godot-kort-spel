extends Node

var battle_manager_reference

var did_extra : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var battle_scene = get_tree().get_root().find_child("BattleScene", true, false)
	battle_manager_reference = battle_scene.get_node("BattleManager")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func tile_ability(card):
	var card_array = [card]
	if battle_manager_reference.successfull_crit:
		if !did_extra:
			card.actions += 1
			did_extra = true
			card.is_selected = true
			battle_manager_reference.attack(card_array)
			if !battle_manager_reference.successfull_crit:
				battle_manager_reference.mult *= 3
			await Global.timer (0.3)
		else:
			did_extra = false
