extends Node2D

var card_database = preload("res://Scripts/card_database.gd")
var card_scene = preload("res://Scenes/card.tscn")
var tile_database = preload("res://Scripts/tile_database.gd")
var tile_scene = load("res://Scenes/tile.tscn")

@onready var card_clip_mask: ColorRect = $CardSlot/ColorRect/ColorRect/CardClipMask
@onready var button: Button = $Button
@onready var reroll_label: Label = $Button/Label
@onready var round_label: Label = $ColorRect/ColorRect/ColorRect/Label2
@onready var money_label: Label = $ColorRect/ColorRect2/ColorRect/ColorRect/Label2
@onready var shop_scene_manager: Node2D = $ShopSceneManager
@onready var continue_label: Label = $ContinueButton/Label

var reroll_count : int = 0
var shop_card_amount : int = 5
var hovered_card : Node2D
var bought_cards = []
var cards_in_shop = []
var start_process : bool = false
var reroll_label_position_y
var continue_label_position_y

signal exit_shop

const CARD_MASK = 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	round_label.text = "Round: " + str(Global.round)
	money_label.text = str(Global.total_money) + "$"
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if start_process:
		card_hover_effect()
		money_label.text = str(Global.total_money) + "$"
	
func add_items_on_start():
	make_new_cards()
	round_label.text = "Round: " + str(Global.round)
	
	reroll_label_position_y = reroll_label.position.y
	continue_label_position_y = continue_label.position.y
	
func get_random_card(amount):
	var card_keys = card_database.CARDS.keys()
	var random_cards = []
	for i in range(amount):
		var random_index = randi() % card_keys.size()
		var random_card_name = card_keys[random_index]
		random_cards.append(random_card_name)
	return random_cards
	
func get_random_tile():
	var tile_keys = tile_database.TILES.keys()
	var random_tiles = []
	for i in 2:
		var random_index = randi() % tile_keys.size()
		var random_tile_name = tile_keys[random_index]
		random_tiles.append(random_tile_name)
	return random_tiles
	
func connect_card_signal(card):
	card.buy_card.connect(buy_card)
	
func buy_card(card):
	var tween = get_tree().create_tween()
	if Global.total_money >= card.price:
		card.price_label.visible = false
		card.button.visible = false
		tween.tween_property(card, "scale", Vector2(0.9, 0.9), 0.05)
		await tween.finished
		
		bought_cards.append(card)
		card.visible = false
		Global.total_money -= card.price
	else:
		tween.tween_property(card.button, "modulate", Color(1.0, 0.5, 0.5), 0.0) # tween för att overrita faden under denna om den är igång
		tween.tween_property(card.button, "modulate", Color(1.0, 1.0, 1.0), 0.5)
	
func make_new_cards():
	#card_slot.clip_contents = true
	var cards = get_random_card(shop_card_amount)
	animate_card_reroll(cards_in_shop)
	cards_in_shop.clear()
	for card_name in cards:

		var new_card_instance = card_scene.instantiate()
		new_card_instance.z_index = 0

		new_card_instance.base_attack = card_database.CARDS[card_name][0]
		new_card_instance.attack = new_card_instance.base_attack
		new_card_instance.base_actions = card_database.CARDS[card_name][1]
		new_card_instance.actions = new_card_instance.base_actions
		new_card_instance.card_type = card_database.CARDS[card_name][2]
		new_card_instance.card_name = card_name
		var random_price = randi() % (3 + reroll_count) + (4 + reroll_count)
		new_card_instance.price = random_price
		
		#new_card_instance.get_node("Textures/DescriptionText").text = card_database.CARDS[card_name][4]
		new_card_instance.get_node("Textures/NamnLabel").text = card_name
		
		if card_database.CARDS[card_name][2] != "Troop":
			new_card_instance.get_node("Textures/AbilityDescriptionText").text = card_database.CARDS[card_name][3]
			
		var image_path = "res://Assets/Images/kort/" + card_name + "_card.png"
		var texture = load(image_path)
		var sprite = new_card_instance.get_node("Textures/ScaleNode/CardSprite")
		if sprite:
			sprite.texture = texture
		else:
			print("Sprite node not found in card instance")
		
		card_clip_mask.add_child(new_card_instance)
		cards_in_shop.append(new_card_instance)
		connect_card_signal(new_card_instance)
		
	align_new_cards(cards_in_shop)
	animate_card_reroll(cards_in_shop)
	await Global.timer(0.5)
	add_price_text()
	
func make_new_tiles():
	var tiles = get_random_tile
	
	
func animate_card_reroll(cards):
	var width : float = card_clip_mask.get_size().x
	for card in cards:
		var tween = get_tree().create_tween()
		tween.tween_property(card, "position", Vector2(card.position.x + width, card.position.y), 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
		card.attack_label.text = str(card.attack)
		card.actions_label.text = str(card.actions)
		adjust_text_size(card)
		if card.card_type != "Spell":
			card.get_node("Textures/ScaleNode/StatDisplay").visible = true
		
func align_new_cards(cards):
	var width : float = card_clip_mask.get_size().x
	var i : float = 1
	for card in cards:
		card.position.x = width * (i / (cards.size() + 1)) - width
		card.position.y = card_clip_mask.get_size().y / 2
		i += 1

func _on_button_pressed() -> void:
	reroll_count += 1
	reroll_label.modulate = Color(0.8, 0.8, 0.8)
	button.disabled = true
	make_new_cards()
	await Global.timer(0.7)
	reroll_label.modulate = Color(1.0, 1.0, 1.0)
	button.disabled = false
	
func _on_button_button_down() -> void:
	reroll_label.position.y = reroll_label_position_y + 3
	
func _on_button_button_up() -> void:
	reroll_label.position.y = reroll_label_position_y
	
func card_hover_effect():
	for card in cards_in_shop:
		var card_texture = card.get_node("Textures")
		if card == hovered_card and card_texture.scale != Vector2(1.05, 1.05):
			card_texture.scale = Vector2(1.05, 1.05)
		elif card != hovered_card and card_texture.scale == Vector2(1.05, 1.05):
			card_texture.scale = Vector2(1, 1)
			
func add_price_text():
	for card in cards_in_shop:
		card.button.visible = true
		var tween = get_tree().create_tween()
		var button_label = card.get_node("MarginContainer/MarginContainer/Price")
		button_label.visible_ratio = 0.0
		button_label.text = "BUY " + str(card.price) + "$"
		tween.tween_property(button_label, "visible_ratio", 1.0, 0.2)
		
func adjust_text_size(card):
	var label = card.get_node("Textures/NamnLabel")
	var font_size = 20
	while label.get_line_count() > 1:
		font_size -= 1
		label.set("theme_override_font_sizes/font_size", font_size)
		
func _change_scene(scene_path : String):
	get_tree().change_scene_to_file(scene_path)

func _on_button_2_pressed() -> void:
	Global.store_card_data(bought_cards)
	exit_shop.emit()
	
func _on_continue_button_pressed() -> void:
	Global.store_card_data(bought_cards)
	exit_shop.emit()

func _on_continue_button_button_down() -> void:
	continue_label.position.y = continue_label_position_y + 3

func _on_continue_button_button_up() -> void:
	continue_label.position.y = continue_label_position_y - 3
