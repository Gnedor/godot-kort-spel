extends Node
var placed_card

func tile_ability(card):
	var battle_scene = get_tree().get_root().find_child("BattleScene", true, false)
	var card_manager = battle_scene.find_child("CardManager", true, false)
	card_manager.placed_card.connect(add_mult)
	placed_card = card
	for played_card in card_manager.played_cards:
		if played_card != card and played_card.card_type == card.card_type:
			card.round_mult *= 1.5
			card.turn_mult *= 1.5
	card.update_card()
			
		
			
func add_mult(card):
	if card.card_name == placed_card.card_name:
		placed_card.round_mult *= 1.5
		placed_card.turn_mult *= 1.5
		placed_card.update_card()
	
