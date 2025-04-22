extends Node2D

var card_scene = load("res://Scenes/card.tscn")

var draw_queue = 0
var cards_in_troop_deck = []
var cards_in_spell_deck = []

var selected_deck

@onready var card_manager: Node2D = $"../CardManager"
@onready var troop_deck_counter: Label = $TroopDeckCounter
@onready var draw_animation: Timer = $DrawAnimation
@onready var spell_deck: Node2D = $"../SpellDeck"
@onready var spell_deck_counter: Label = $"../SpellDeck/SpellDeckCounter"
@onready var scene_manager: Node2D = $"../SceneManager"

#func draw_card(amount : int):
	#draw_queue = amount
	#if cards_in_deck.size() > 0 and draw_queue > 0:
		#draw_animation.start()
	
func _ready() -> void:
	scene_manager.on_scene_enter.connect(on_enter)
	SignalManager.removed_card.connect(check_for_deleted_cards)
	
func on_enter():
	for card in Global.stored_cards:
		card.visible = false
		card.z_index = 0
		card.get_node("Area2D/CollisionShape2D").disabled = true
			
	Global.stored_cards.clear()
	
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
	card.adjust_text_size()
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
		var card_type = CardDatabase.CARDS[card_name][2]
		card_manager.add_child(new_card_instance)
		
		if card_type != "Spell":
			new_card_instance.position = position
		else:
			new_card_instance.position = spell_deck.position
			
		new_card_instance.z_index = 0
		new_card_instance.visible = false
		new_card_instance.get_node("Area2D/CollisionShape2D").disabled = true
		
		new_card_instance.base_attack = CardDatabase.CARDS[card_name][0]
		new_card_instance.turn_attack = new_card_instance.base_attack
		new_card_instance.attack = new_card_instance.base_attack
		new_card_instance.base_actions = CardDatabase.CARDS[card_name][1]
		new_card_instance.turn_actions = new_card_instance.base_actions
		new_card_instance.actions = new_card_instance.base_actions
		new_card_instance.card_type = CardDatabase.CARDS[card_name][2]
		new_card_instance.card_name = card_name
		new_card_instance.trait_1 = CardDatabase.CARDS[card_name][5]
		
		new_card_instance.adjust_card_details()
		new_card_instance.adjust_description_text()
		new_card_instance.adjust_text_size()
			
		if card_type != "Spell":
			cards_in_troop_deck.append(new_card_instance)
		else:
			cards_in_spell_deck.append(new_card_instance)
		
		card_manager.update_card(new_card_instance)
		
func add_card_to_deck(card_name : String, card_attack : int, card_actions : int):
	var new_card_instance = card_scene.instantiate()
	var card_type = CardDatabase.CARDS[card_name][2]
	
	if card_type != "Spell":
		new_card_instance.position = position
	else:
		new_card_instance.position = spell_deck.position
	card_manager.add_child(new_card_instance)
	
	new_card_instance.z_index = 0
	new_card_instance.visible = false
	new_card_instance.get_node("Area2D/CollisionShape2D").disabled = true
	
	new_card_instance.base_attack = card_attack
	new_card_instance.turn_attack = card_attack
	new_card_instance.attack = card_attack
	new_card_instance.base_actions = card_actions
	new_card_instance.actions = card_actions
	new_card_instance.turn_actions = card_actions
	new_card_instance.card_type = CardDatabase.CARDS[card_name][2]
	new_card_instance.card_name = card_name
	new_card_instance.get_node("Area2D/CollisionShape2D").disabled = true
	
	new_card_instance.adjust_card_details()
	
	if card_type != "Spell":
		cards_in_troop_deck.append(new_card_instance)
	else:
		cards_in_spell_deck.append(new_card_instance)
		
	card_manager.update_card(new_card_instance)
		
func add_cards_on_start():
	if Global.round == 1:
		selected_deck = CardDatabase[Global.selected_deck]
			
		for card in selected_deck:
			add_new_card_to_deck(card["name"], card["amount"])
	else:
		#for card in Global.stored_cards:
		for card in cards_in_troop_deck:
			card.z_index = 0
			card.visible = false
			#cards_in_troop_deck.append(card)
			card.position = position
				
		for card in cards_in_spell_deck:
			card.z_index = 0
			card.visible = false
			#cards_in_spell_deck.append(card)
			card.position = spell_deck.position
			
	cards_in_troop_deck.shuffle()
	cards_in_spell_deck.shuffle()
	
	troop_deck_counter.text = str(cards_in_troop_deck.size())
	spell_deck_counter.text = str(cards_in_spell_deck.size())
	
#func adjust_text_size(card):
	#var label = card.get_node("Textures/NamnLabel")
	#var font_size = 20
	#while label.get_line_count() > 1:
		#font_size -= 1
		#label.set("theme_override_font_sizes/font_size", font_size)
		
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
	card.trait_1 = copy_card.trait_1
	card.trait_2 = copy_card.trait_2
	card.tag = copy_card.tag
	
	card.adjust_text_size()
	card_manager.update_card(card)
	card.adjust_card_details()
	card.place_tag(card.tag)
	card.update_traits()
	
func create_card_copy(card):
	var card_copy = card_scene.instantiate()
	
	card_copy.card_name = card.card_name
	card_copy.card_type = card.card_type
	card_copy.base_attack = card.turn_attack
	card_copy.turn_attack = card_copy.base_attack
	card_copy.attack = card_copy.base_attack
	card_copy.base_actions = card.turn_actions
	card_copy.actions = card_copy.base_actions
	card_copy.turn_actions = card_copy.base_actions
	card_copy.ability_script = card.ability_script
	card_copy.trait_1 = card.trait_1
	card_copy.trait_2 = card.trait_2
	
	card_copy.adjust_card_details()
	
	return card_copy
	
#func adjust_description_text(label):
	#label.custom_minimum_size = Vector2(260, 0)
	#label.set_autowrap_mode(2)
	#if label.get_line_count() <= 1:
		#label.custom_minimum_size = Vector2(0, 0)
		#label.set_autowrap_mode(0)
	
#func adjust_card_details_and_script(card):
	#var card_name = card.card_name
	#card.card_type = CardDatabase.CARDS[card_name][2]
	#card.get_node("Textures/NamnLabel").text = card_name
	#adjust_text_size(card)
	#card.name_label.text = card_name
		#
	#if CardDatabase.CARDS[card_name][3]:
		#card.description_label.text = "[center]" + str(CardDatabase.CARDS[card_name][3]) + "[/center]"
		#Global.color_text(card.description_label)
	#else:
		#card.description_label.text = "[center]Does nothing[/center]"
	#adjust_description_text(card.description_label)
	#
	#if card.card_type != "Troop":
		#var new_card_ability_script_path = CardDatabase.CARDS[card_name][4]
		#var ability_script = load(new_card_ability_script_path).new()
		#card.ability_script = ability_script
		#card.add_child(ability_script)
			#
	#var image_path = "res://Assets/images/kort/" + card_name + "_card.png"
	#var texture = load(image_path)
	#var sprite = card.card_sprite
	#if sprite:
		#sprite.texture = texture
	#else:
		#print("Sprite node not found")
		#
	#sprite = card.action_sprite
	#if card.card_type != "Troop":
		#image_path = "res://Assets/images/ActionTypes/" + card.card_type + "_type.png"
		#texture = load(image_path)
#
		#if sprite:
			#sprite.texture = texture
		#else:
			#print("Sprite node not found")
	#else:
		#sprite.texture = null
		#
	#card.update_traits()
		
func check_for_deleted_cards():
	for card in cards_in_troop_deck.duplicate():
		if !is_instance_valid(card):
			cards_in_troop_deck.erase(card)
			
	for card in cards_in_spell_deck.duplicate():
		if !is_instance_valid(card):
			cards_in_spell_deck.erase(card)
	
