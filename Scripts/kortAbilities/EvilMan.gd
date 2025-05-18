extends Node

var card_manager_reference
var battle_manager_reference

func _ready() -> void:
	var battle_scene = get_tree().get_root().find_child("BattleScene", true, false)
	card_manager_reference = battle_scene.get_node("CardManager")
	battle_manager_reference = battle_scene.get_node("BattleManager")

func trigger_ability(card_reference):
	var added_attack : int = 0
	battle_manager_reference.ability_effect(card_reference)
	
	for card in card_manager_reference.played_cards:
		var original_attack = card.attack
		card.attack /= 2
		added_attack += (original_attack - card.attack)
		if card.turn_attack > card.attack:
			card.turn_attack = card.attack
		card.update_card()
		
	card_reference.attack += added_attack
	card_reference.turn_attack = card_reference.attack
	card_reference.update_card()
		
