extends Node

func tile_ability(card):
	var battle_scene = get_tree().get_root().find_child("BattleScene", true, false)
	var card_manager = battle_scene.find_child("CardManager", true, false)
	var i = 0
	
	for played_card in card_manager.played_cards:
		if played_card.card_name == card.card_name and played_card != card:
			i += 1
			
	if i > 0:
		for j in range(i):
			card.multiplier *= (1.5)
