extends Node2D

const CARD_BOUNDRY = 1300

var troop_cards = []
var spell_cards = []
var cards_in_collection = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func create_cards(deck_reference):
	troop_cards.clear()
	spell_cards.clear()
	cards_in_collection.clear()
	var next_deck : int = 1
	
	var troop_deck = deck_reference.cards_in_troop_deck.duplicate()
	troop_deck.sort_custom(func(a, b): return a.card_name.naturalnocasecmp_to(b.card_name) < 0)
	
	var spell_deck = deck_reference.cards_in_spell_deck.duplicate()
	spell_deck.sort_custom(func(a, b): return a.card_name.naturalnocasecmp_to(b.card_name) < 0)
	
	for card in troop_deck:
		var card_copy = deck_reference.create_card_copy(card)
		card_copy.get_node("Area2D").collision_layer = 1 << 8
		troop_cards.append(card_copy)
		cards_in_collection.append(card_copy)
			
	for card in spell_deck:
		var card_copy = deck_reference.create_card_copy(card)
		card_copy.get_node("Area2D").collision_layer = 1 << 8
		spell_cards.append(card_copy)
		cards_in_collection.append(card_copy)
	align_cards()

func align_cards():
	var page = 0
	var max_page : int
	if troop_cards.size() > spell_cards.size():
		max_page = (troop_cards.size() / 6)
	else:
		max_page = (spell_cards.size() / 6)
		
	for i in range(6):
		if troop_cards[i + (12 * page)]:
			var card = troop_cards[i + (12 * page)]
			card.position = Vector2(240 + (CARD_BOUNDRY * (i + 1) / 6), 192)
		
		if troop_cards[(6 + i) + (12 * page)]:
			var card = troop_cards[(6 + i) + (12 * page)]
			card.position = Vector2(240 + (CARD_BOUNDRY * (i + 1) / 6), 428)
			
		if spell_cards[i + (12 * page)]:
			var card = spell_cards[i + (12 * page)]
			card.position = Vector2(240 + (CARD_BOUNDRY * (i + 1) / 6), 652)
		
		if spell_cards[(6 + i) + (12 * page)]:
			var card = spell_cards[(6 + i) + (12 * page)]
			card.position = Vector2(240 + (CARD_BOUNDRY * (i + 1) / 6), 888)
		
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
	var card_textures = card.get_node("Textures")
	card.scale = Vector2(1.05, 1.05)
	if card.card_type != "Spell":
		card.get_node("Textures/ScaleNode/StatDisplay").visible = true
		
func hover_off_effect(card):
	var card_textures = card.get_node("Textures")
	card.scale = Vector2(1, 1)
	card.get_node("Textures/ScaleNode/StatDisplay").visible = false
			
	
