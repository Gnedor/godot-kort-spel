extends Node

var quota : float = 40
var total_money : float = 0
var base_money : float = 5
var total_damage : float
var base_modifier_rerolls : int = 2 

var highest_damage : float = 0
var highest_money : float = 0
var round : int = 1
var stored_cards = []
var stored_tiles = []
var stored_tags = []
var window_size : Vector2 = Vector2(1920, 1080)

var scene_index : int = -2
var is_game_paused : bool = false
var enter_from_start : bool = true

var played_cards = []

var selected_deck = "Example_deck"

var modifiers = {"Burned card": 1}

func store_card(card):
	stored_cards.append(card)

func store_tile(tile : Node2D):
	stored_tiles.append(tile)
	
func timer(time):
	await get_tree().create_timer(time).timeout
	
func reset_game():
	SignalManager.signal_emitter("reset_game")
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
	change_color("Echo", Color.html("#639bff"), label)
	
func change_color(word, color, label):
	var colored_word = "[color=" + color.to_html() + "]" + word + "[/color]"
	label.text = label.text.replace(word, colored_word)
	
func round_number(label, num : float):
	var suffixes = ["", "k", "M", "B", "T"]
	
	if num < 100:
		label.text = str(snapped(num, 0.01))
		return
	
	if num < 100000:
		label.text = str(round(num))
		return
	
	var magnitude = 0
	while num >= 1000.0 and magnitude <= suffixes.size() - 1:
		num /= 1000.0
		magnitude += 1

	# If larger than "T", use scientific notation
	if magnitude >= suffixes.size():
		var exponent = int(floor(log(num * pow(1000, magnitude)) / log(10)))
		var base = (num * pow(1000, magnitude)) / pow(10, exponent)
		var str_base = str(round(base * 100) / 100.0)  # Keep 2 decimals
		if str_base.ends_with(".0"):
			str_base = str_base.substr(0, str_base.length() - 2)
		label.text = str(str_base + "e+" + str(exponent))
		return

	# Limit to 3 significant digits
	var str_n := ""
	if num >= 100:
		str_n = str(round(num))
	elif num >= 10:
		str_n = str(round(num * 10) / 10.0)
	else:
		str_n = str(round(num * 100) / 100.0)

	if str_n.ends_with(".0"):
		str_n = str_n.substr(0, str_n.length() - 2)

	label.text = str(str_n + suffixes[magnitude])
	
