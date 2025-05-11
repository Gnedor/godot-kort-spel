extends Node2D

var card_scene = preload("res://Scenes/card.tscn")
var tile_scene = load("res://Scenes/tile.tscn")

@onready var card_collection: Node2D = $CardCollection
@onready var card_clip_mask: ColorRect = $CardSlot/ColorRect/ColorRect/CardClipMask
@onready var button: Button = $Button
@onready var reroll_label: Label = $Button/Label
@onready var round_label: Label = $ColorRect/ColorRect/ColorRect/Label2
@onready var money_label: Label = $ColorRect/ColorRect2/ColorRect/ColorRect/Label2
@onready var shop_scene_manager: Node2D = $ShopSceneManager
@onready var continue_label: Label = $ContinueButton/Label
@onready var shop_input_manager: Node2D = $ShopInputManager
@onready var tile_clip_mask: ColorRect = $TileClipMask
@onready var buy_button_1: Node2D = $TileSlot/BuyButton1
@onready var buy_button_2: Node2D = $TileSlot2/BuyButton2
@onready var card_manager_screen: Node2D = $CardCollection/CardManagerScreen

@onready var back_label: Label = $CardCollection/BackButton/BackLabel

var deck

var reroll_count : int = 0
var shop_card_amount : int = 5
var hovered_card : Node2D
var hovered_tile : Node2D
var selected_card : Node2D

var cards_in_shop = []
var tiles_in_shop = []
var tile_labels = []

var start_process : bool = false
var rerolling : bool = false
var viewing_collection : bool = false
var managing_card : bool = false
var reroll_label_position_y
var continue_label_position_y

signal exit_shop

const CARD_MASK = 2
const LABEL_MAX_SIZE = 280
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	card_manager_screen.trash_pressed.connect(trash_card)
	deck = get_tree().current_scene.get_node("BattleScene/TroopDeck")
	
	tile_labels = [buy_button_1.label, buy_button_2.label]
	
	shop_scene_manager.on_scene_enter.connect(on_enter)
	buy_button_1.buy_button_pressed.connect(buy_tile)
	buy_button_2.buy_button_pressed.connect(buy_tile)
	
	#round_label.text = "Round: " + str(Global.round)
	#money_label.text = str(Global.total_money) + "$"
	
	
func on_enter():
	pass
	#round_label.text = "Round: " + str(Global.round)
	#money_label.text = str(Global.total_money) + "$"
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	money_label.text = str(Global.total_money) + "$"
	
	if Global.scene_index == 0:
		if start_process:
			if !rerolling:
				card_hover_effect()
				tile_hover_effect()
				
			if viewing_collection and !managing_card:
				card_collection.align_card_hover(hovered_card)
				
func add_items_on_start():
	make_new_cards()
	make_new_tiles()
	
	reroll_label_position_y = reroll_label.position.y
	continue_label_position_y = continue_label.position.y
	
	card_manager_screen.add_tags()
	
func get_random_card(amount):
	var card_keys = CardDatabase.CARDS.keys()
	var random_cards = []
	for i in range(amount):
		var random_index = randi() % card_keys.size()
		var random_card_name = card_keys[random_index]
		random_cards.append(random_card_name)
	return random_cards
	
func get_random_tile():
	var tile_keys = TileDatabase.TILES.keys()
	var random_tiles = []
	for i in range(2):
		var random_index = randi() % tile_keys.size()
		var random_tile_name = tile_keys[random_index]
		random_tiles.append(random_tile_name)
	return random_tiles
	
func connect_card_signal(card):
	card.buy_button.buy_button_pressed.connect(buy_card)
	
func buy_card(card):
	var tween = get_tree().create_tween()
	if Global.total_money >= card.price:
		card.buy_button.visible = false
		tween.tween_property(card, "scale", Vector2(0.9, 0.9), 0.05)
		await tween.finished
		
		card.visible = false
		Global.total_money -= card.price
		card.scale = Vector2(1, 1)
		Global.store_card(card)
		cards_in_shop.erase(card)
		if card.card_type != "Spell":
			deck.cards_in_troop_deck.append(card)
		else:
			deck.cards_in_spell_deck.append(card)
		var card_manager_reference = get_node("/root/Main/BattleScene/CardManager")
		card.reparent(card_manager_reference)
		
	else:
		tween.tween_property(card.buy_button.button, "modulate", Color(1.0, 0.5, 0.5), 0.0) # tween för att overrita faden under denna om den är igång
		tween.tween_property(card.buy_button.button, "modulate", Color(1.0, 1.0, 1.0), 0.5)
	
func buy_tile(tile_slot):
	var bought_tile : Node2D
	var tween = get_tree().create_tween()
	if Global.total_money >= tiles_in_shop[0].price:
		if tile_slot == $TileSlot:
			buy_button_1.button.visible = false
			bought_tile = tiles_in_shop[0]
		else:
			buy_button_2.button.visible = false
			if tiles_in_shop.size() > 1:
				bought_tile = tiles_in_shop[1]
			else:
				bought_tile = tiles_in_shop[0]
			
		Global.total_money -= bought_tile.price
		tween.tween_property(bought_tile, "scale", Vector2(0.9, 0.9), 0.05)
		await tween.finished
		
		bought_tile.visible = false
		Global.store_tile(bought_tile)
		tiles_in_shop.erase(bought_tile)
		var tiles_folder_reference = get_node("/root/Main/BattleScene/TilesFolder")
		bought_tile.reparent(tiles_folder_reference)
		
	else:
		if tile_slot == $TileSlot:
			tween.tween_property(buy_button_1.button, "modulate", Color(1.0, 0.5, 0.5), 0.0) # tween för att overrita faden under denna om den är igång
			tween.tween_property(buy_button_1.button, "modulate", Color(1.0, 1.0, 1.0), 0.5)
		else:
			tween.tween_property(buy_button_2.button, "modulate", Color(1.0, 0.5, 0.5), 0.0) # tween för att overrita faden under denna om den är igång
			tween.tween_property(buy_button_2.button, "modulate", Color(1.0, 1.0, 1.0), 0.5)
		
	
func make_new_cards():
	#card_slot.clip_contents = true
	var cards = get_random_card(shop_card_amount)
	animate_card_reroll(cards_in_shop)
	remove_old_cards(cards_in_shop.duplicate())
	cards_in_shop.clear()
	for card_name in cards:
		var new_card_instance = card_scene.instantiate()
		new_card_instance.z_index = 0

		new_card_instance.base_attack = CardDatabase.CARDS[card_name][0]
		new_card_instance.attack = new_card_instance.base_attack
		new_card_instance.base_actions = CardDatabase.CARDS[card_name][1]
		new_card_instance.actions = new_card_instance.base_actions
		new_card_instance.card_type = CardDatabase.CARDS[card_name][2]
		new_card_instance.card_name = card_name
		var random_price = randi() % (3 + reroll_count) + (4 + reroll_count)
		new_card_instance.price = random_price
		new_card_instance.trait_1 = CardDatabase.CARDS[card_name][5]
		new_card_instance.get_node("Area2D/CollisionShape2D").disabled = false
		
		if new_card_instance.card_type != "Troop":
			var new_card_ability_script_path = CardDatabase.CARDS[card_name][4]
			var ability_script = load(new_card_ability_script_path).new()
			new_card_instance.ability_script = ability_script
			new_card_instance.add_child(ability_script)
			
		if new_card_instance.card_type == "Spell":
			new_card_instance.get_node("Textures/ScaleNode/StatDisplay").visible = false
		card_clip_mask.add_child(new_card_instance)  
		cards_in_shop.append(new_card_instance)
		connect_card_signal(new_card_instance)
		new_card_instance.adjust_card_details()
		
	align_new_cards(cards_in_shop)
	animate_card_reroll(cards_in_shop)
	await Global.timer(0.5)
	add_card_price_text()
	
#func adjust_card_details(card):
	#var card_name = card.card_name
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
	#var image_path = "res://Assets/images/kort/" + card_name + "_card.png"
	#var texture = load(image_path)
	#var sprite = card.card_sprite
	#if sprite:
		#sprite.texture = texture
	#else:
		#print("Sprite node not found")
	#card.description.visible = false
		#
	#if card.card_type != "Troop":
		#image_path = "res://Assets/images/ActionTypes/" + card.card_type + "_type.png"
		#texture = load(image_path)
		#sprite = card.action_sprite
		#if sprite:
			#sprite.texture = texture
		#else:
			#print("Sprite node not found")
			#
	#card.update_traits()
	
func make_new_tiles():
	var tiles = get_random_tile()
	animate_tile_reroll(tiles_in_shop)
	remove_old_tiles(tiles_in_shop.duplicate())
	tiles_in_shop.clear()
	remove_tile_price_text()
	
	for tile_name in tiles:
		var new_tile_instance = tile_scene.instantiate()
		var tile_ability_script_path = TileDatabase.TILES[tile_name][1]
		
		var ability_script = load(tile_ability_script_path).new()
		new_tile_instance.add_child(ability_script)  # Add to tree FIRST
		new_tile_instance.ability_script = ability_script  # THEN assign
		
		tile_clip_mask.add_child(new_tile_instance)
		
		new_tile_instance.description.visible = false
		new_tile_instance.z_index = 1
		new_tile_instance.tile_name = tile_name
		new_tile_instance.price = (5 + reroll_count * 2)
		new_tile_instance.tile_type = TileDatabase.TILES[tile_name][2]
		new_tile_instance.name_label.text = tile_name
		new_tile_instance.description_label.text = "[center]" + str(TileDatabase.TILES[tile_name][0]) + "[/center]"
		
		adjust_description_text(new_tile_instance.description_label)
		Global.color_text(new_tile_instance.description_label)
		
		var image_path = "res://Assets/Images/Tiles/" + tile_name + "_tile.png"
		var texture = load(image_path)
		var sprite = new_tile_instance.get_node("Sprite2D")
		if sprite:
			sprite.texture = texture
		else:
			print("Sprite node not found in card instance")
		tiles_in_shop.append(new_tile_instance)
		
	align_new_tiles(tiles_in_shop)
	animate_tile_reroll(tiles_in_shop)
	await Global.timer(0.5)
	add_tile_price_text()
	
func animate_card_reroll(cards):
	var width : float = card_clip_mask.get_size().x
	for card in cards:
		var tween = get_tree().create_tween()
		tween.tween_property(card, "position", Vector2(card.position.x + width, card.position.y), 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
		card.attack_label.text = str(card.attack)
		card.actions_label.text = str(card.actions)
		card.adjust_text_size()
		if card.card_type != "Spell":
			card.get_node("Textures/ScaleNode/StatDisplay").visible = true
			
func animate_tile_reroll(tiles):
	for tile in tiles:
		var tween = get_tree().create_tween()
		tween.tween_property(tile, "position:y", tile.position.y + 400, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
		
func align_new_cards(cards):
	var width : float = card_clip_mask.get_size().x
	var i : float = 1
	for card in cards:
		card.position.x = width * (i / (cards.size() + 1)) - width
		card.position.y = card_clip_mask.get_size().y / 2
		i += 1
		
func align_new_tiles(tiles):
	tiles[0].position = Vector2(152, -240)
	tiles[1].position = Vector2(488, -240)

func _on_button_pressed() -> void:
	rerolling = true
	reroll_count += 1
	reroll_label.modulate = Color(0.8, 0.8, 0.8)
	button.disabled = true
	make_new_cards()
	make_new_tiles()
	await Global.timer(0.7)
	reroll_label.modulate = Color(1.0, 1.0, 1.0)
	button.disabled = false
	rerolling = false
	
func _on_button_button_down() -> void:
	reroll_label.position.y = reroll_label_position_y + 3
	
func _on_button_button_up() -> void:
	reroll_label.position.y = reroll_label_position_y
	
func card_hover_effect():
	for card in cards_in_shop:
		var card_texture = card.get_node("Textures")
		if card == hovered_card and card_texture.scale != Vector2(1.05, 1.05):
			card_texture.scale = Vector2(1.05, 1.05)
			card.card_description.visible = true
		elif card != hovered_card and card_texture.scale == Vector2(1.05, 1.05):
			card_texture.scale = Vector2(1, 1)
			card.card_description.visible = false
			
func tile_hover_effect():
	if tiles_in_shop:
		for tile in tiles_in_shop:
			if tile == hovered_tile:
				tile.scale = Vector2(1.05, 1.05)
				tile.description.visible = true
			elif tile != hovered_tile:
				tile.scale = Vector2(1, 1)
				tile.description.visible = false
			
func add_card_price_text():
	for card in cards_in_shop:
		card.buy_button.button.visible = true
		var tween = get_tree().create_tween()
		var button_label = card.get_node("BuyButton").label
		button_label.visible_ratio = 0.0
		button_label.text = "BUY " + str(card.price) + "$"
		tween.tween_property(button_label, "visible_ratio", 1.0, 0.2)
		
func add_tile_price_text():
	buy_button_1.button.visible = true
	buy_button_2.button.visible = true
	for label in tile_labels:
		var tween = get_tree().create_tween()
		label.visible_ratio = 0.0
		label.text = "BUY " + str(tiles_in_shop[0].price) + "$"
		tween.tween_property(label, "visible_ratio", 1.0, 0.2)
		
func remove_tile_price_text():
	for label in tile_labels:
		var tween = get_tree().create_tween()
		tween.tween_property(label, "visible_ratio", 0.0, 0.2)
	await Global.timer(0.2)
	buy_button_1.button.visible = false
	buy_button_2.button.visible = false
		
#func adjust_text_size(card):
	#var label = card.get_node("Textures/NamnLabel")
	#var font_size = 20
	#while label.get_line_count() > 1:
		#font_size -= 1
		#label.set("theme_override_font_sizes/font_size", font_size)
		
func _change_scene(scene_path : String):
	get_tree().change_scene_to_file(scene_path)
	
func _on_continue_button_pressed() -> void:
	exit_shop.emit()

func _on_continue_button_button_down() -> void:
	continue_label.position.y = continue_label_position_y + 3

func _on_continue_button_button_up() -> void:
	continue_label.position.y = continue_label_position_y
	
func adjust_description_text(label):
	label.custom_minimum_size = Vector2(LABEL_MAX_SIZE, 0)
	label.set_autowrap_mode(2)
	
	if label.get_line_count() <= 1:
		label.custom_minimum_size = Vector2(0, 0)
		label.set_autowrap_mode(0)
	
func remove_old_cards(cards):
	await Global.timer(0.5)
	for card in cards:
		card.queue_free()
		
func remove_old_tiles(tiles):
	await Global.timer(0.5)
	for tile in tiles:
		tile.queue_free()

func _on_manage_card_pressed() -> void:
	#card_collection.create_cards_global()
	card_collection.align_cards()
	await shop_scene_manager.move_to_card_collection()
	viewing_collection = true

func _on_back_button_pressed() -> void:
	shop_scene_manager.move_from_card_collection()
	viewing_collection = false
	card_collection.page = 0
	
func select_card(card):
	selected_card = card
	card_collection.toggle_collision(true)
	shop_scene_manager.move_to_manage_card(selected_card)
	card_collection.align_card_hover(null)
	card.stat_display.visible = true
	if selected_card.card_type != "Spell":
		selected_card.visible = true

func deselect_card(card):
	selected_card = null
	card_collection.toggle_collision(false)
	card.stat_display.visible = false

func _on_back_button_down() -> void:
	back_label.position.y += 3

func _on_back_button_up() -> void:
	back_label.position.y -= 3

func trash_card(card):
	card.stat_display.visible = false
	var trash_card_anim = card_manager_screen.trash_card
	#var tween = get_tree().create_tween()
	#tween.tween_property(card, "scale", Vector2(2, 2), 0.2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	trash_card_anim.get_node("AnimationPlayer").play("trash_card_anim")
	trash_card_anim.visible = true
	
	#await tween.finished
	await Global.timer(0.15)
	
	selected_card = null
	card.free()
	SignalManager.signal_emitter("removed_card")

	await Global.timer(0.4)
	
	trash_card_anim.get_node("AnimationPlayer").play("RESET")
	trash_card_anim.visible = false
	card_collection.toggle_collision(false)
	shop_scene_manager.move_from_manage_card(null)
