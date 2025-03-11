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
@onready var trash_card: Button = $"../TrashCard"
@onready var card_collection: Node2D = $"../CardCollection"

var shop_scene_up
var shop_scene_down

signal on_scene_enter
signal on_scene_exit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shop.exit_shop.connect(remove_shop_ui)
	shop_scene_up = [card_slot, button, round_display]
	shop_scene_down = [tile_slot, tile_slot_2, continue_button, tile_clip_mask, trash_card]
	instant_remove_shop_ui()
	
	#await add_shop_ui()
	#
	#shop.add_items_on_start()
	#shop.start_process = true

func on_enter_scene():
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

func move_to_trash_card():
	var parent = get_parent()
	card_collection.move_in_cards()
	var tween = get_tree().create_tween()
	tween.parallel().tween_property(get_parent(), "global_position:x", parent.position.x - 1920, 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	for card in card_collection.cards_in_collection:
		tween.parallel().tween_property(card, "global_position:x", card.position.x - 1920, 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	card_collection.create_page_indicators()
	#for node in shop_scene_up:
		#tween.parallel().tween_property(node, "global_position:x", node.position.x - Global.window_size.x, 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	#for node in shop_scene_down:
		#tween.parallel().tween_property(node, "global_position:x", node.position.x - Global.window_size.x, 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	#tween.parallel().tween_property(card_collection, "global_position:x", get_parent().position.x, 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	
func move_from_trash_card():
	var parent = get_parent()
	var tween = get_tree().create_tween()
	tween.tween_property(get_parent(), "global_position:x", parent.position.x + 1920, 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	for card in card_collection.cards_in_collection:
		tween.parallel().tween_property(card, "global_position:x", card.position.x + 1920, 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	card_collection.move_out_cards()
	#for node in shop_scene_up:
		#tween.parallel().tween_property(node, "global_position:x", node.position.x + Global.window_size.x, 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	#for node in shop_scene_down:
		#tween.parallel().tween_property(node, "global_position:x", node.position.x + Global.window_size.x, 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	#tween.parallel().tween_property(card_collection, "global_position:x", Global.window_size.x, 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
