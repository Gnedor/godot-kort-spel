extends Node2D

var deck

const CARD = preload("res://Scenes/card.tscn")

const CARD_BOUNDRY = 1300

var troop_cards = []
var spell_cards = []
var cards_in_collection = []
var page_indicators = []

var page : int = 0
var max_page : int = 0

@onready var arrow_left: Sprite2D = $Button_left/Arrow_left
@onready var arrow_right: Sprite2D = $Button_right/Arrow_right

@onready var button_left: Button = $Button_left
@onready var button_right: Button = $Button_right

var page_indicator: PackedScene = preload("res://Scenes/page_indicator.tscn")
@onready var h_box_container: HBoxContainer = $HBoxContainer

func _ready() -> void:
	deck = get_tree().current_scene.get_node("BattleScene/TroopDeck")
	
func move_in_cards():
	troop_cards = deck.cards_in_troop_deck.duplicate()
	spell_cards = deck.cards_in_spell_deck.duplicate()
	cards_in_collection = troop_cards + spell_cards
		
	for card in cards_in_collection:
		card.get_node("Area2D/CollisionShape2D").disabled = false
		card.z_index = 110
		card.visible = true
		card.get_node("Area2D").collision_layer = 1 << 8

	align_cards()
	
func move_out_cards():
	for card in cards_in_collection:
		card.get_node("Area2D/CollisionShape2D").disabled = true
		card.get_node("Area2D").collision_layer = 1 << 1
		card.z_index = 1

func align_cards():
	update_page_indicators()
	troop_cards.sort_custom(func(a, b): return a.card_name.naturalnocasecmp_to(b.card_name) < 0)
	spell_cards.sort_custom(func(a, b): return a.card_name.naturalnocasecmp_to(b.card_name) < 0)
	for card in cards_in_collection:
		card.visible = true
		card.position = Vector2 (-100, -100)
		
		checkPage()
		
	var scene_pos = global_position.x
		
	for i in range(6):
		if troop_cards.size() >= i + (12 * page) + 1:
			var card = troop_cards[i + (12 * page)]
			card.position = Vector2(scene_pos + 240 + (CARD_BOUNDRY * (i + 1) / 6), 192)
		
		if troop_cards.size() >= (6 + i) + (12 * page) + 1:
			var card = troop_cards[(6 + i) + (12 * page)]
			card.position = Vector2(scene_pos + 240 + (CARD_BOUNDRY * (i + 1) / 6), 428)
			
		if spell_cards.size() >= i + (12 * page) + 1:
			var card = spell_cards[i + (12 * page)]
			card.position = Vector2(scene_pos + 240 + (CARD_BOUNDRY * (i + 1) / 6), 652)
			
		if spell_cards.size() >= ((6 + i) + (12 * page)) + 1:
			var card = spell_cards[(6 + i) + (12 * page)]
			card.position = Vector2(scene_pos + 240 + (CARD_BOUNDRY * (i + 1) / 6), 888)
			
func align_card_hover(hovered_card):
	for card in cards_in_collection:
		if card == hovered_card and !card.is_hovering:
			if !card.is_selected:
				hover_effect(card)
				card.is_hovering = true
		elif card != hovered_card:
			hover_off_effect(card)
			card.is_hovering = false
			
func hover_effect(card):
	#var card_textures = card.get_node("Textures")
	card.scale = Vector2(1.05, 1.05)
	card.card_description.visible = true
	if card.card_type != "Spell":
		card.get_node("Textures/ScaleNode/StatDisplay").visible = true
		
func hover_off_effect(card):
	#var card_textures = card.get_node("Textures")
	card.scale = Vector2(1, 1)
	card.card_description.visible = false
	card.get_node("Textures/ScaleNode/StatDisplay").visible = false

func create_page_indicators():
	if h_box_container.get_child_count() != max_page + 1:
		for dot in page_indicators.duplicate():
			dot.queue_free()
			page_indicators.pop_front()

		for i in range(max_page + 1):
			var new_indicator = page_indicator.instantiate()
			h_box_container.add_child(new_indicator)
			page_indicators.append(new_indicator)

	if page > max_page:
		page -= 1
		align_cards()
		
	update_page_indicators()
	
func update_page_indicators():
	for i in page_indicators.size():
		if i == page:
			page_indicators[i].modulate = Color(1, 1, 1)
		else:
			page_indicators[i].modulate = Color(0.4, 0.4, 0.4)

func _on_button_left_pressed() -> void:
	if page > 0:
		page -= 1
		align_cards()

func _on_button_left_button_up() -> void:
	arrow_left.position.y -= 2

func _on_button_left_button_down() -> void:
	arrow_left.position.y += 2


func _on_button_right_button_down() -> void:
	arrow_right.position.y += 2

func _on_button_right_button_up() -> void:
	arrow_right.position.y -= 2

func _on_button_right_pressed() -> void:
	if page < max_page:
		page += 1
		align_cards()
		
func checkForDeletedCards():
	for card in cards_in_collection.duplicate():
		if !is_instance_valid(card):
			cards_in_collection.erase(card)
			spell_cards.erase(card)
			troop_cards.erase(card)
	checkPage()
	create_page_indicators()
	
func checkPage():
	if troop_cards.size() > spell_cards.size():
		max_page = ((troop_cards.size() - 1) / 12)
	else:
		max_page = ((spell_cards.size() - 1) / 12)
		
	if page == 0:
		button_left.disabled = true
	else:
		button_left.disabled = false
		
	if page == max_page:
		button_right.disabled = true
	else:
		button_right.disabled = false
		
func toggle_collision(toggle : bool):
	checkForDeletedCards()
	for card in cards_in_collection:
		card.area_2d.get_child(0).disabled = toggle
	
