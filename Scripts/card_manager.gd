extends Node2D

var card_scene = load("res://Scenes/card.tscn")
@onready var deck: Node2D = $"../TroopDeck"
@onready var spell_deck: Node2D = $"../SpellDeck"
@onready var hand_counter: Label = $HandCounter
@onready var discard_pile: Node2D = $"../DiscardPile"
@onready var card_slots: Node = $"../CardSlots"
@onready var battle_manager: Node2D = $"../BattleManager"
@onready var input_manager: Node2D = $"../InputManager"
@onready var end_turn_label: Label = $"../BattleManager/EndTurn/EndTurnLabel"
@onready var card_collection: Node2D = $"../CardCollection"
@onready var back_label: Label = $"../CardCollection/BackButton/BackLabel"
@onready var darken_background: ColorRect = $"../BattleManager/DarkenBackground"

var dragged_card : Node2D
var window_size : Vector2
var hand_boundry : float
var is_hovering_over_card : bool = false
var highest_card
var played_cards = []
var discarded_cards = []
var cards_in_hand = []

var viewing_collection : bool = false

const CARD_MOVE_SPEED = 3000 # pixels per second
const CARD_DRAW_SPEED = 4000

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	battle_manager.end_round.connect(on_round_end)
	#window_size = get_viewport().size sätt på om window size ska vara dynamisk
	window_size = Vector2(1920, 1080)
	hand_boundry = window_size.x * 0.6
	# uppdaterar window_size varje gång den ändras
	#get_viewport().connect("size_changed", _on_size_changed) sätt på om window size ska vara dynamisk
	
	input_manager.card_relesed_on_slot.connect(place_card_on_slot)
	input_manager.card_clicked_on_slot.connect(select_card)
	input_manager.click_on_discard.connect(discard_selected_cards)
	input_manager.click_on_deck.connect(show_card_collection)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.scene_index == 1:
		# kollar om man har klickat på ett kort och flyttar kortet till muspekaren
		if dragged_card:
			dragged_card.position = Vector2(
				clamp(get_global_mouse_position().x, 0, window_size.x), 
				clamp(get_global_mouse_position().y, 0, window_size.y))
				#sätter de selectade kortet längst fram
			dragged_card.z_index = cards_in_hand.size() + 1000
			sort_by_x_position(cards_in_hand)
			
func sort_by_x_position(array: Array):
	array.sort_custom(compare_x_position)
	align_cards()

# Function to compare two objects based on their x_position
func compare_x_position(a, b):
	if a.position.x < b.position.x:
		return true
	return false
	
func swap_elements(array : Array, index1 : int, index2 : int):
	var temp = array[index1]
	array[index1] = array[index2]
	array[index2] = temp
	
func place_card_on_slot(slot):
	if !slot.is_occupied and dragged_card and !dragged_card.is_placed and !dragged_card.card_type == "Spell":
		cards_in_hand.erase(dragged_card)
		dragged_card.z_index = 3
		dragged_card.position = slot.position
		
		slot.is_occupied = true
		dragged_card.is_placed = true
		
		hover_off_effect(dragged_card)
		played_cards.append(dragged_card)
		
		dragged_card.stat_display.visible = true
		dragged_card.actions -= 1
		
		sort_played_cards()

		if slot.occupied_tile:
			if slot.occupied_tile.tile_type == "OnPlay":
				slot.occupied_tile.ability_script.tile_ability(dragged_card)
		
		if dragged_card.card_type == "OnPlayTroop":
			dragged_card.ability_script.trigger_ability(dragged_card)
		update_card(dragged_card)
		Global.played_cards.append(dragged_card.card_name)
	align_cards()
	
func _on_size_changed():
	window_size = get_viewport().size
	hand_boundry = window_size.x * 0.6
	
func align_cards():
	var i = 0
	for card in cards_in_hand:
		#begränsar korten inom hand_boundry och plaserar dem lika brett utmed den
		var card_pos_x = (window_size.x / 2) - (hand_boundry / 2) + (hand_boundry * (i + 1) / (cards_in_hand.size() + 1))
		var new_position = Vector2(card_pos_x, window_size.y - 152)
		
		hand_counter.text = str(cards_in_hand.size())
		if card != dragged_card:
			var anim : int = 1
			if card.global_position.y <= window_size.y - 151 and card.global_position.y >= window_size.y -153:
				anim = 2
			animate_card_snap(card, new_position, CARD_MOVE_SPEED, anim)
			card.z_index = i + 3
		i += 1
		
func align_cards_on_draw(amount_drawn : int):
	var i = 0
	for card in cards_in_hand:
		#begränsar korten inom hand_boundry och plaserar dem lika brett utmed den
		var card_pos_x = (window_size.x / 2) - (hand_boundry / 2) + (hand_boundry * (i + 1) / (cards_in_hand.size() + 1 + amount_drawn))
		var new_position = Vector2(card_pos_x, window_size.y - 152)
		card.z_index = i + 3
		hand_counter.text = str(cards_in_hand.size())
		animate_card_snap(card, new_position, CARD_DRAW_SPEED, 2)
		i += 1
			
func draw_cards(troop_amount : int, spell_amount : int):
	var amount_to_be_drawn_troop
	var amount_to_be_drawn_spell
	
	if deck.cards_in_troop_deck.size() < troop_amount:
		amount_to_be_drawn_troop = deck.cards_in_troop_deck.size()
	else: 
		amount_to_be_drawn_troop = troop_amount
		
	if deck.cards_in_spell_deck.size() < spell_amount:
		amount_to_be_drawn_spell = deck.cards_in_spell_deck.size()
	else: 
		amount_to_be_drawn_spell = spell_amount
		
	var amount_to_be_drawn_total = amount_to_be_drawn_troop + amount_to_be_drawn_spell
		
	align_cards_on_draw(amount_to_be_drawn_total)
	var amount_in_hand = cards_in_hand.size()
	var drawn_card
	var selected_deck
		
	for i in amount_to_be_drawn_total:
		if amount_to_be_drawn_troop > 0:
			drawn_card = deck.cards_in_troop_deck[0]
			amount_to_be_drawn_troop -= 1
		else:
			drawn_card = deck.cards_in_spell_deck[0]
			amount_to_be_drawn_spell -= 1
			
		var card_pos_x = (window_size.x / 2) - (hand_boundry / 2) + (hand_boundry * (i + 1 + amount_in_hand) / (1 + amount_in_hand + amount_to_be_drawn_total))
		var new_position = Vector2(card_pos_x, window_size.y - 152)
		drawn_card.z_index = i + 3 + amount_in_hand
			
		deck.on_draw_card(drawn_card)
		hand_counter.text = (str(cards_in_hand.size()))
		if drawn_card.card_type == "Spell":
			drawn_card.global_position = spell_deck.global_position
		else:
			drawn_card.global_position = deck.global_position
			
		drawn_card.get_node("Area2D/CollisionShape2D").disabled = false
		animate_card_snap(drawn_card, new_position, CARD_DRAW_SPEED, 2)

		await get_tree().create_timer(0.05).timeout
		
func hover_effect(card):
	var card_textures = card.get_node("Textures")
	card.scale = Vector2(1.05, 1.05)
	animate_card_snap(card_textures, Vector2(0, -75), 700, 1)
	card.description.visible = true
	if card.card_type != "Spell":
		card.stat_display.visible = true
		
func hover_off_effect(card):
	var card_textures = card.get_node("Textures")
	card.scale = Vector2(1, 1)
	animate_card_snap(card_textures, Vector2(0, 0), 10000, 1)
	card.description.visible = false
	card.stat_display.visible = false
	
func select_effect(card):
	card.scale = Vector2(1.1, 1.1)
	card.select_border.visible = true
	
func deselect_effect(card):
	card.scale = Vector2(1, 1)
	card.select_border.visible = false
		
func check_for_highest_z_index(cards):
	highest_card = cards[0]
	for i in cards.size():
		if cards[i].z_index > highest_card.z_index:
			highest_card = cards[i]
	return highest_card
	
func align_card_hover(hovered_card):
	for card in cards_in_hand:
		if card == hovered_card and !card.is_hovering:
			if !card.is_selected:
				hover_effect(card)
				card.is_hovering = true
		elif card != hovered_card:
			hover_off_effect(card)
			card.is_hovering = false
	for card in played_cards:
		if card == hovered_card and !card.description.visible and card.card_type:
			card.description.visible = true
		elif card != hovered_card and card.description.visible:
			card.description.visible = false
			
func animate_card_snap(card, position, speed, num):
	if card.global_position != position:
		var tween = get_tree().create_tween()
		#if card.global_position.y != window_size.y - 152:
		if num == 1:
			tween.tween_property(card, "position", position, find_duration(card.position, position, speed * 2)).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		else:
			tween.tween_property(card, "position", position, 0.2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		await tween.finished
	
func find_duration(pos1, pos2, speed):
	var distance = pos1.distance_to(pos2)
	var duration = distance / speed
	return duration
	
func update_card(card):
	card.attack_label.text = str(card.attack)
	card.actions_label.text = str(card.actions)
		
func select_card(card):
	if !battle_manager.active_select:
		if !card.is_selected and card.actions > 0:
			select_effect(card)
			card.is_selected = true
		else:
			deselect_effect(card)
			card.is_selected = false
		
func deselect_all():
	for card in played_cards:
		deselect_effect(card)
		card.is_selected = false
		
func sort_played_cards():
	played_cards.sort_custom(func(a, b): return a.position.x < b.position.x)
	
func discard_selected_cards(cards, status : String):
	for card in cards.duplicate():
		if status == "played":
			for i in range(5):
				if card_slots.get_node("CardSlot" + str(i + 1)).global_position == card.global_position:
					card_slots.get_node("CardSlot" + str(i + 1)).is_occupied = false
					
		if card.is_selected == true:
			deselect_effect(card)
			card.stat_display.visible = false
			card.is_selected = false
			card.is_placed = false
			card.is_discarded = true
			card.get_node("Area2D/CollisionShape2D").disabled = true
			played_cards.erase(card)
			card.z_index = 0
			await animate_card_snap(card, discard_pile.position, CARD_MOVE_SPEED, 1)
			discarded_cards.append(card)
			card.visible = false
			
func show_card_collection():
	viewing_collection = true
	darken_background.z_index = cards_in_hand.size() + 4
	card_collection.z_index = darken_background.z_index + 1
	card_collection.move_in_cards()
	var tween = get_tree().create_tween()
	
	for card in card_collection.cards_in_collection:
		card.position.y += Global.window_size.y
		tween.parallel().tween_property(card, "position:y", card.position.y - Global.window_size.y, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
		
	card_collection.create_page_indicators()
	tween.parallel().tween_property(card_collection, "position", Vector2(0, 0), 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	battle_manager.darken_screen()

func _on_back_button_button_down() -> void:
	back_label.position.y += 3

func _on_back_button_button_up() -> void:
	back_label.position.y -= 3

func _on_back_button_pressed() -> void:
	var tween = get_tree().create_tween()
	tween.parallel().tween_property(card_collection, "position", Vector2(0, Global.window_size.y), 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	for card in card_collection.cards_in_collection:
		tween.parallel().tween_property(card, "position:y", card.position.y + Global.window_size.y, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
		
	await tween.finished
	card_collection.move_out_cards()
	battle_manager.brighten_screen()
	card_collection.page = 0
	viewing_collection = false
	
func trigger_card_ability(card):
	card.ability_script.trigger_ability(card, battle_manager, deck, self)
	
func on_round_end():
	for slot in $"../CardSlots".get_children():
		slot.is_occupied = false
		slot.occupied_tile = null
		for card in played_cards:
			card.is_placed = false
