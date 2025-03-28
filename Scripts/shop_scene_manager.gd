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
@onready var manage_card: Button = $"../ManageCard"
@onready var card_collection: Node2D = $"../CardCollection"
@onready var card_managing_position: Node2D = $"../CardCollection/CardManagingPosition"
@onready var darken_screen: ColorRect = $DarkenScreen
@onready var card_manager_screen: Node2D = $"../CardCollection/CardManagerScreen"

var shop_scene_up
var shop_scene_down

var org_card_pos

signal on_scene_enter
signal on_scene_exit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	card_manager_screen.back_pressed.connect(move_from_manage_card)
	shop.exit_shop.connect(remove_shop_ui)
	shop_scene_up = [card_slot, button, round_display]
	shop_scene_down = [tile_slot, tile_slot_2, continue_button, tile_clip_mask, manage_card]
	instant_remove_shop_ui()

func on_enter_scene():
	shop.round_label.text = "Round: " + str(Global.round)
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

func move_to_card_collection():
	var parent = get_parent()
	card_collection.move_in_cards()
	var tween = get_tree().create_tween()
	tween.parallel().tween_property(get_parent(), "global_position:x", parent.position.x - 1920, 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	for card in card_collection.cards_in_collection:
		tween.parallel().tween_property(card, "global_position:x", card.position.x - 1920, 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	card_collection.create_page_indicators()
	
func move_from_card_collection():
	var parent = get_parent()
	var tween = get_tree().create_tween()
	tween.tween_property(get_parent(), "global_position:x", parent.position.x + 1920, 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	for card in card_collection.cards_in_collection:
		tween.parallel().tween_property(card, "global_position:x", card.position.x + 1920, 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	card_collection.move_out_cards()
	
func move_to_manage_card(card):
	card_manager_screen.on_enter()
	shop.managing_card = true
	card.z_index = 130
	org_card_pos = card.position
	card_manager_screen.selected_card = card
	dissable_collection_buttons()
	
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_IN_OUT)
	
	tween.parallel().tween_property(card, "scale", Vector2(3, 3), 0.2)
	tween.parallel().tween_property(card, "position", card_managing_position.global_position, 0.2)
	tween.parallel().tween_property(darken_screen, "color", Color(0, 0, 0, 0.9), 0.2)
	tween.parallel().tween_property(card_manager_screen, "position", Vector2(0, 0), 0.2)
	
func move_from_manage_card(card):
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_IN_OUT)
	
	if card:
		tween.parallel().tween_property(card, "scale", Vector2(1, 1), 0.2)
		tween.parallel().tween_property(card, "position", org_card_pos, 0.2)
		
	tween.parallel().tween_property(darken_screen, "color", Color(0, 0, 0, 0), 0.2)
	tween.parallel().tween_property(card_manager_screen, "position", Vector2(1920, 0), 0.2)
	await tween.finished
	
	card_manager_screen.update_labels()
	enable_collection_buttons()
	card_collection.checkForDeletedCards()
	shop.managing_card = false
	card_manager_screen.visible = false
	
	if card:
		shop.deselect_card(card)
		card.z_index = 110
	
func dissable_collection_buttons():
	for child in card_collection.get_children():
		if child is Button:
			child.disabled = true
			
func enable_collection_buttons():
	for child in card_collection.get_children():
		if child is Button:
			child.disabled = false
