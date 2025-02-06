extends Node2D

var card_scene = load("res://Scenes/card.tscn")
var card_database = preload("res://Scripts/card_database.gd")

var draw_queue = 0
var cards_in_troop_deck = []
var cards_in_spell_deck = []

var selected_deck

@onready var card_manager: Node2D = $"../CardManager"
@onready var troop_deck_counter: Label = $TroopDeckCounter
@onready var draw_animation: Timer = $DrawAnimation
@onready var spell_deck: Node2D = $"../SpellDeck"
@onready var spell_deck_counter: Label = $"../SpellDeck/SpellDeckCounter"
	
#func draw_card(amount : int):
	#draw_queue = amount
	#if cards_in_deck.size() > 0 and draw_queue > 0:
		#draw_animation.start()
	
func _on_draw_animation_timeout() -> void:
	card_manager.cards_in_hand.append(cards_in_troop_deck[0])
	cards_in_troop_deck[0].visible = true
	cards_in_troop_deck[0].get_node("Area2D/CollisionShape2D").disabled = false
	card_manager.align_cards()
	cards_in_troop_deck[0].in_deck = false
	cards_in_troop_deck.remove_at(0)
	troop_deck_counter.text = str(cards_in_troop_deck.size())
	
	draw_queue -= 1
	if cards_in_troop_deck.size() > 0 and draw_queue > 0:
		draw_animation.start()
	else:
		draw_animation.stop()
		
func on_draw_card(card : Node2D):
	card_manager.cards_in_hand.append(card)
	card.visible = true
	adjust_text_size(card)
	card.get_node("Area2D/CollisionShape2D").disabled = false
	card.in_deck = false
	if card.card_type != "Spell":
		cards_in_troop_deck.remove_at(0)
		troop_deck_counter.text = str(cards_in_troop_deck.size())
	else:
		cards_in_spell_deck.remove_at(0)
		spell_deck_counter.text = str(cards_in_spell_deck.size())
		
func add_new_card_to_deck(card_name : String, times : int):
	for i in range(times):
		var new_card_instance = card_scene.instantiate()
		var card_type = card_database.CARDS[card_name][2]
		
		if card_type != "Spell":
			new_card_instance.position = position
		else:
			new_card_instance.position = spell_deck.position
			
		new_card_instance.z_index = 0
		new_card_instance.visible = false
		new_card_instance.get_node("Area2D/CollisionShape2D").disabled = true
		
		new_card_instance.base_attack = card_database.CARDS[card_name][0]
		new_card_instance.turn_attack = new_card_instance.base_attack
		new_card_instance.attack = new_card_instance.base_attack
		new_card_instance.base_actions = card_database.CARDS[card_name][1]
		new_card_instance.turn_actions = new_card_instance.base_actions
		new_card_instance.actions = new_card_instance.base_actions
		new_card_instance.card_type = card_database.CARDS[card_name][2]
		new_card_instance.card_name = card_name
		new_card_instance.get_node("Textures/NamnLabel").text = card_name
		adjust_text_size(new_card_instance)
	
		if card_type != "Troop":
			new_card_instance.get_node("Textures/AbilityDescriptionText").text = card_database.CARDS[card_name][3]
			var new_card_ability_script_path = card_database.CARDS[card_name][4]
			new_card_instance.ability_script = load(new_card_ability_script_path).new()
			
		if card_type != "Spell":
			cards_in_troop_deck.append(new_card_instance)
		else:
			cards_in_spell_deck.append(new_card_instance)
			
		card_manager.add_child(new_card_instance)
		
		var image_path = "res://Assets/Images/kort/" + card_name + "_card.png"
		var texture = load(image_path)
		var sprite = new_card_instance.get_node("Textures/ScaleNode/CardSprite")
		if sprite:
			sprite.texture = texture
		else:
			print("Sprite node not found in card instance")
		
		card_manager.update_card(new_card_instance)
		
func add_card_to_deck(card_name : String, card_attack : int, card_actions : int):
	var new_card_instance = card_scene.instantiate()
	var card_type = card_database.CARDS[card_name][2]
	
	if card_type != "Spell":
		new_card_instance.position = position
	else:
		new_card_instance.position = spell_deck.position
	
	new_card_instance.z_index = 0
	new_card_instance.visible = false
	new_card_instance.get_node("Area2D/CollisionShape2D").disabled = true
	
	new_card_instance.base_attack = card_attack
	new_card_instance.turn_attack = card_attack
	new_card_instance.attack = card_attack
	new_card_instance.base_actions = card_actions
	new_card_instance.actions = card_actions
	new_card_instance.turn_actions = card_actions
	new_card_instance.card_type = card_database.CARDS[card_name][2]
	new_card_instance.card_name = card_name
	new_card_instance.get_node("Textures/NamnLabel").text = card_name
	
	if card_type != "Troop":
		new_card_instance.get_node("Textures/AbilityDescriptionText").text = card_database.CARDS[card_name][3]
		var new_card_ability_script_path = card_database.CARDS[card_name][4]
		new_card_instance.ability_script = load(new_card_ability_script_path).new()
	
	if card_type != "Spell":
		cards_in_troop_deck.append(new_card_instance)
	else:
		cards_in_spell_deck.append(new_card_instance)
		
	card_manager.add_child(new_card_instance)
	
	var image_path = "res://Assets/Images/kort/" + card_name + "_card.png"
	var texture = load(image_path)
	var sprite = new_card_instance.get_node("Textures/ScaleNode/CardSprite")
	if sprite:
		sprite.texture = texture
	else:
		print("Sprite node not found in card instance")
		
	card_manager.update_card(new_card_instance)
		
func add_cards_on_start():
	cards_in_troop_deck.clear()
	cards_in_spell_deck.clear()
	if Global.round == 1:
		selected_deck = card_database.EXAMPLE_DECK
			
		for card in selected_deck:
			add_new_card_to_deck(card["name"], card["amount"])
	else:
		for card in Global.stored_cards:
			add_card_to_deck(card["name"], card["attack"], card["actions"])
			
	cards_in_troop_deck.shuffle()
	cards_in_spell_deck.shuffle()
	
	troop_deck_counter.text = str(cards_in_troop_deck.size())
	spell_deck_counter.text = str(cards_in_spell_deck.size())
	
func adjust_text_size(card):
	var label = card.get_node("Textures/NamnLabel")
	var font_size = 20
	while label.get_line_count() > 1:
		font_size -= 1
		label.set("theme_override_font_sizes/font_size", font_size)
		
func replace_card_with_copy(card, copy_card):
	card.card_name = copy_card.card_name
	card.card_type = copy_card.card_type
	card.base_attack = copy_card.turn_attack
	card.turn_attack = copy_card.turn_attack
	card.attack = copy_card.turn_attack
	card.base_actions = copy_card.turn_actions
	card.actions = copy_card.turn_actions
	card.turn_actions = copy_card.turn_actions
	card.card_type = copy_card.card_type
	card.card_name = copy_card.card_name
	card.ability_script = copy_card.ability_script
	card.get_node("Textures/NamnLabel").text = copy_card.get_node("Textures/NamnLabel").text
	var image_path = "res://Assets/Images/kort/" + card.card_name + "_card.png"
	var texture = load(image_path)
	var sprite = card.get_node("Textures/ScaleNode/CardSprite")
	if sprite:
		sprite.texture = texture
	else:
		print("Sprite node not found in card instance")
	card_manager.update_card(card)
