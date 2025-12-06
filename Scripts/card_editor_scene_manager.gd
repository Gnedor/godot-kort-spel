extends Control

@onready var card_collection: Node2D = $"../CardCollection"

signal on_scene_exit

var tween
var first_up := true
var in_collection := false #används så man inte klickar flera kort i collectionen

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_continue_button_pressed() -> void:
	first_up = true
	on_scene_exit.emit()

func _on_card_slot_button_down() -> void:
	#tween = get_tree().create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	#tween.tween_property(%CardSlot, "scale", Vector2(1.02, 1.02), 0.1)
	pass


func _on_card_slot_button_up() -> void:
	#tween = get_tree().create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	#tween.tween_property(%CardSlot, "scale", Vector2(1.08, 1.08), 0.1)
	#tween.tween_property(%CardSlot, "scale", Vector2(1.0, 1.0), 0.1)
	pass
	
func _on_card_slot_pressed() -> void:
	if !first_up:
		var card = $"..".stored_card
		tween = get_tree().create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
		tween.parallel().tween_property(card, "scale", Vector2(0.9, 0.9), 0.1)
		await tween.finished
		card.visible = false 
	collection_up()

func collection_up():
	if first_up == true:
		card_collection.move_in_cards()
		first_up = false
	card_collection.align_cards()
	card_collection.create_page_indicators()
	tween = get_tree().create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property($"..", "position:y", -1080, 0.3)
	
	for card in card_collection.cards_in_collection:
		tween.parallel().tween_property(card, "position:y", card.global_position.y - 1080, 0.3)
		
	await Global.timer(0.3)
	in_collection = true
	
func collection_down():
	tween = get_tree().create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property($"..", "position:y", 0, 0.3)
	
	for card in card_collection.cards_in_collection:
		tween.parallel().tween_property(card, "position:y", card.position.y + 1080, 0.3)
	
func _on_back_button_pressed() -> void:
	collection_down()


func _on_card_slot_mouse_entered() -> void:
	tween = get_tree().create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(%CardSlot, "scale", Vector2(1.05, 1.05), 0.1)


func _on_card_slot_mouse_exited() -> void:
	tween = get_tree().create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(%CardSlot, "scale", Vector2(1.0, 1.0), 0.1)
