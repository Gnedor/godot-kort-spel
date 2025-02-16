extends Node

var quota : float = 40
var total_money : float = 0
var base_money : float = 5
var total_damage : float

var highest_damage : int = 0
var highest_money : int = 0
var round : int = 1
var stored_cards = []
var stored_tiles = []
var window_size : Vector2 = Vector2(1920, 1080)

var played_cards = []

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
	
func reset_game():
	quota = 40
	total_money = 0
	base_money = 5
	highest_damage = 0
	highest_money = 0
	round = 1
	played_cards.clear()
	
func find_common_card():
	var frequency := {}
	
	# Count occurrences
	for card in played_cards:
		if card in frequency:	
			frequency[card] += 1
		else:
			frequency[card] = 1
	
	# Find the most common item
	var most_common_card = null
	var max_count = 0
	
	for key in frequency:
		if frequency[key] > max_count:
			max_count = frequency[key]
			most_common_card = key
	return most_common_card
