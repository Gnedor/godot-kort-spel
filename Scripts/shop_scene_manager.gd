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

var shop_scene_up
var shop_scene_down

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shop.exit_shop.connect(remove_shop_ui)
	shop_scene_up = [card_slot, button, round_display, money_display]
	shop_scene_down = [tile_slot, tile_slot_2, continue_button, tile_clip_mask]
	
	instant_remove_shop_ui()
	await add_shop_ui()
	
	shop.add_items_on_start()
	shop.start_process = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
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
	call_deferred("_change_scene")
	
func _change_scene():
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
	
func instant_remove_shop_ui():
	for node in shop_scene_up:
		node.position.y -= 1000
	for node in shop_scene_down:
		node.position.y += 1000
