extends Node2D

var deck

const CARD = preload("res://Scenes/card.tscn")

const CARD_BOUNDRY = 1300

var troop_cards = []
var spell_cards = []
var cards_in_collection = []
var page_indicators = []

const CARD_MASK = 256
var hovered_card

var page : int = 0
var max_page : int = 0

var in_focus:= false

@onready var arrow_left: Sprite2D = $Button_left/Arrow_left
@onready var arrow_right: Sprite2D = $Button_right/Arrow_right

@onready var button_left: Button = $Button_left
@onready var button_right: Button = $Button_right

var page_indicator: PackedScene = preload("res://Scenes/page_indicator.tscn")
@onready var h_box_container: HBoxContainer = $HBoxContainer

func _ready() -> void:
	deck = get_tree().current_scene.get_node("BattleScene/TroopDeck")
	
func _process(delta: float) -> void:
	if in_focus:
		var new_hovered_card = check_for_card()
		
		if new_hovered_card != hovered_card and hovered_card:
			hover_off_effect(hovered_card)
			
		hovered_card = new_hovered_card
			
		if hovered_card:
			hover_effect(hovered_card)
			
func move_in_cards():
	in_focus = true
	troop_cards = deck.cards_in_troop_deck.duplicate()
	spell_cards = deck.cards_in_spell_deck.duplicate()
	cards_in_collection = troop_cards + spell_cards
		
	for card in cards_in_collection:
		if !is_instance_valid(card):
			continue
		card.get_node("Area2D/CollisionShape2D").disabled = false
		hover_off_effect(card)
		card.z_index = z_index + 1
		card.visible = true
		card.get_node("Area2D").collision_layer = 1 << 8
		
	align_cards()
	
func move_out_cards():
	in_focus = false
	for card in cards_in_collection:
		if !is_instance_valid(card):
			continue
		card.get_node("Area2D/CollisionShape2D").disabled = true
		card.get_node("Area2D").collision_layer = 1 << 1
		card.z_index = 1
		card.visible = false
		
func align_cards():
	update_page_indicators()
	
	# Clean up invalid cards first
	troop_cards = troop_cards.filter(func(card): return is_instance_valid(card))
	spell_cards = spell_cards.filter(func(card): return is_instance_valid(card))
	cards_in_collection = cards_in_collection.filter(func(card): return is_instance_valid(card))
	
	troop_cards.sort_custom(func(a, b): return a.card_name.naturalnocasecmp_to(b.card_name) < 0)
	spell_cards.sort_custom(func(a, b): return a.card_name.naturalnocasecmp_to(b.card_name) < 0)
	
	for card in cards_in_collection:
		card.visible = true
		card.position = Vector2(-100, -100)
		card.update_card()
		
		checkPage()
		
	var scene_pos = global_position.x
	var page_index = page * 12
		
	for i in range(6):
		if troop_cards.size() >= i + (page_index) + 1:
			var card = troop_cards[i + (page_index)]
			card.position = Vector2(scene_pos + 240 + (CARD_BOUNDRY * (i + 1) / 6), 192 + global_position.y)
		
		if troop_cards.size() >= (6 + i) + (page_index) + 1:
			var card = troop_cards[(6 + i) + (page_index)]
			card.position = Vector2(scene_pos + 240 + (CARD_BOUNDRY * (i + 1) / 6), 428 + global_position.y)
			
		if spell_cards.size() >= i + (page_index) + 1:
			var card = spell_cards[i + (page_index)]
			card.position = Vector2(scene_pos + 240 + (CARD_BOUNDRY * (i + 1) / 6), 652 + global_position.y)
			
		if spell_cards.size() >= ((6 + i) + (page_index)) + 1:
			var card = spell_cards[(6 + i) + (page_index)]
			card.position = Vector2(scene_pos + 240 + (CARD_BOUNDRY * (i + 1) / 6), 888 + global_position.y)
			
func hover_effect(card):
	card.scale = Vector2(1.05, 1.05)
	card.z_index = z_index + 2
	card.hover_effect()
		
func hover_off_effect(card):
	card.scale = Vector2(1, 1)
	card.z_index = z_index + 1
	card.hover_off_effect()

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
	AudioManager.play_click_sound()
	
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
	AudioManager.play_click_sound()
	
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
		
func check_for_card():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = CARD_MASK
	var result = space_state.intersect_point(parameters)
	# om den hittar kort returnerar den parent Noden
	if result.size() > 0:
		return result[0].collider.get_parent()
	else:
		return null
	
