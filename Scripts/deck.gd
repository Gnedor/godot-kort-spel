extends Node2D

var card_scene = preload("res://Scenes/card.tscn")

var draw_queue = 0
var cards_in_troop_deck = []
var cards_in_spell_deck = []

var selected_deck

signal cards_ready

@onready var card_manager: Node2D = $"../CardManager"
@onready var troop_deck_counter: Label = $TroopDeckCounter
@onready var draw_animation: Timer = $DrawAnimation
@onready var spell_deck: Node2D = $"../SpellDeck"
@onready var spell_deck_counter: Label = $"../SpellDeck/SpellDeckCounter"
@onready var scene_manager: Node2D = $"../SceneManager"
	
func _ready() -> void:
	BattleContext.deck = self
	scene_manager.on_scene_enter.connect(on_enter)
	SignalManager.removed_card.connect(check_for_deleted_cards)
	SignalManager.reset_game.connect(delete_all_card_references)
	
func on_enter():
	Global.stored_cards = Global.stored_cards.filter(func(card): return is_instance_valid(card))
	for card in Global.stored_cards:
		card.visible = false
		card.z_index = 0
		card.get_node("Area2D/CollisionShape2D").disabled = true
		
	add_cards_on_start()
		
	
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
		var card_data = CardDatabase.CARDS[card_name] 
		
		if card_type != "Spell":
			new_card_instance.position = position
		else:
			new_card_instance.position = spell_deck.position
			
		new_card_instance.z_index = 0
		new_card_instance.visible = false
		
		new_card_instance.base_attack = card_data[0]
		new_card_instance.turn_attack = card_data[0]
		new_card_instance.attack = card_data[0]
		new_card_instance.base_actions = card_data[1]
		new_card_instance.turn_actions = card_data[1]
		new_card_instance.actions = card_data[1]
		new_card_instance.card_name = card_name
		new_card_instance.trait_1 = card_data[5]
		
		card_manager.add_child(new_card_instance)
		
		new_card_instance.adjust_card_details()
		new_card_instance.adjust_description_text()
		new_card_instance.adjust_text_size()
			
		if card_type != "Spell":
			cards_in_troop_deck.append(new_card_instance)
		else:
			cards_in_spell_deck.append(new_card_instance)
		
		new_card_instance.update_card()
		Global.store_card(new_card_instance)
		
		if i % 3 == 0:
			await get_tree().process_frame
		
	
func add_cards_on_start():
	if Global.round == 1:
		selected_deck = CardDatabase[Global.selected_deck]
			
		for card in selected_deck:
			await add_new_card_to_deck(card["name"], card["amount"])
	else:
		cards_in_troop_deck.clear()
		cards_in_spell_deck.clear()
		
		for card in Global.stored_cards:
			if card.card_type != "Spell":
				cards_in_troop_deck.append(card)
				card.position = position

			else:
				cards_in_spell_deck.append(card)
				card.position = spell_deck.position
		
	cards_in_troop_deck.shuffle()
	cards_in_spell_deck.shuffle()
	
	troop_deck_counter.text = str(cards_in_troop_deck.size())
	spell_deck_counter.text = str(cards_in_spell_deck.size())
	
	cards_ready.emit()
		
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
	card.update_card()
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
		
func check_for_deleted_cards():
	for card in cards_in_troop_deck.duplicate():
		if !is_instance_valid(card):
			cards_in_troop_deck.erase(card)
			
	for card in cards_in_spell_deck.duplicate():
		if !is_instance_valid(card):
			cards_in_spell_deck.erase(card)
			
func delete_all_card_references():
	cards_in_troop_deck.clear()
	cards_in_spell_deck.clear()
	
	
func _on_area_2d_mouse_entered() -> void:
	$AnimationPlayer.play("grow")

func _on_area_2d_mouse_exited() -> void:
	$AnimationPlayer.play("shrink")
	
