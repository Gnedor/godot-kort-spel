extends Node

var quota : float = 40
var total_money : float = 0
var base_money : float = 5
var total_damage : float
var round : int = 1
var stored_cards = []
var stored_tiles = []

var selected_deck = "EXAMPLE_DECK"

func store_card_data(cards : Array):
	for card in cards:
		var card_data = {
			"name" = card.card_name,
			"attack" = card.base_attack,
			"actions" = card.base_actions,
		}
		stored_cards.append(card_data)

func store_tile_data(tiles : Array):
	for tile in tiles:
		stored_tiles.append(tile.tile_name)
	
func timer(time):
	await get_tree().create_timer(time).timeout
