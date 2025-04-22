extends Node

var quota : float = 40
var total_money : float = 0
var base_money : float = 5
var total_damage : float

var highest_damage : float = 0
var highest_money : float = 0
var round : int = 1
var stored_cards = []
var stored_tiles = []
var stored_tags = []
var window_size : Vector2 = Vector2(1920, 1080)

var scene_index : int = 0

var played_cards = []

var selected_deck = "Example_deck"

func store_card(card):
	stored_cards.append(card)

func store_tile(tile : Node2D):
	stored_tiles.append(tile)
	
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
	
func color_text(label):
	change_color("Damage", Color.html("#ac3232"), label)
	change_color("Actions", Color.html("#639bff"), label)
	change_color("Poison", Color.html("#6abe30"), label)
	change_color("Fracture", Color.html("#898989"), label)
	change_color("Crit", Color.html("#ff6161"), label)
	
func change_color(word, color, label):
	var colored_word = "[color=" + color.to_html() + "]" + word + "[/color]"
	label.text = label.text.replace(word, colored_word)
	
