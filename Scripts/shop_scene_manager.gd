extends Node2D

@onready var card_slot: ColorRect = $"../CardSlot"
@onready var tile_slot: ColorRect = $"../TileSlot"
@onready var tile_slot_2: ColorRect = $"../TileSlot2"
@onready var button: Button = $"../Button"
@onready var round_display: ColorRect = $"../ColorRect"
@onready var money_display: ColorRect = $"../ColorRect/ColorRect2"
@onready var shop: Node2D = $".."
@onready var continue_button: Button = $"../ContinueButton"
@onready var tile_clip_mask: ColorRect = $"../TileClipMask"
@onready var darken_screen: ColorRect = $DarkenScreen
@onready var spell_deck: Node2D = $"../SpellDeck"
@onready var card_collection: Node2D = $"../CardCollection"

var shop_scene_up
var shop_scene_down

var org_card_pos

signal on_scene_enter
signal on_scene_exit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shop.exit_shop.connect(remove_shop_ui)
	shop_scene_up = [card_slot, button, round_display]
	shop_scene_down = [tile_slot, tile_slot_2, continue_button, tile_clip_mask, spell_deck]
	instant_remove_shop_ui()

func on_enter_scene():
	shop.round_label.text = "Round: " + str(Global.round)
	set_deck_image()
	await add_shop_ui()
	
	shop.add_items_on_start()
	shop.start_process = true
	on_scene_enter.emit()
	
func add_shop_ui():
	var tween = get_tree().create_tween()
	
	for node in shop_scene_up:
		tween.parallel().tween_property(node, "position:y", node.position.y + 1000, 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	for node in shop_scene_down:
		tween.parallel().tween_property(node, "position:y", node.position.y - 1000, 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	
func remove_shop_ui():
	var tween = get_tree().create_tween()
	
	for node in shop_scene_up:
		tween.parallel().tween_property(node, "position:y", node.position.y - 1000, 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)

	for node in shop_scene_down:
		tween.parallel().tween_property(node, "position:y", node.position.y + 1000, 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)

	await tween.finished
	#call_deferred("_change_scene")
	
	on_scene_exit.emit()
	
func _change_scene():
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
	
func instant_remove_shop_ui():
	for node in shop_scene_up:
		node.position.y -= 1000
	for node in shop_scene_down:
		node.position.y += 1000
		
func set_deck_image():
	var deck = $"..".deck
	var image = spell_deck.get_node("Sprite2D")
	image.texture = deck.get_node("Sprite2D").texture
	
func enter_collection():
	card_collection.move_in_cards()
	card_collection.align_cards()
	card_collection.create_page_indicators()
	
	var tween
	tween = get_tree().create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property(shop, "position:x", 3840 - 1920, 0.3)
	
	for card in card_collection.cards_in_collection:
		tween.parallel().tween_property(card, "position:x", card.global_position.x - 1920, 0.3)
		
func exit_collection():
	var tween
	tween = get_tree().create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property(shop, "position:x", 3840, 0.3)
	
	for card in card_collection.cards_in_collection:
		tween.parallel().tween_property(card, "position:x", card.global_position.x + 1920, 0.3)
	
