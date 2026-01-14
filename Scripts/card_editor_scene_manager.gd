extends Control

@onready var card_collection: Node2D = $"../CardCollection"
@onready var card_editor: Control = $".."

signal on_scene_exit
signal on_scene_enter

var tween
var first_up := true
var in_collection := false #används så man inte klickar flera kort i collectionen

var tag_desc_down : bool = false

func on_enter_scene():
	on_scene_enter.emit()
	%"Trait 1".visible = false
	%"Trait 2".visible = false

func _on_continue_button_pressed() -> void:
	first_up = true
	on_scene_exit.emit()
	
func _on_card_slot_pressed() -> void:
	if !first_up:
		var card = card_editor.stored_card
		if card:
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
	tween.parallel().tween_property(card_editor, "position:y", -1080, 0.3)
	
	for card in card_collection.cards_in_collection:
		tween.parallel().tween_property(card, "position:y", card.global_position.y - 1080, 0.3)
		
	await Global.timer(0.3)
	card_editor.stored_card = null
	in_collection = true
	
func collection_down():
	tween = get_tree().create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property(card_editor, "position:y", 0, 0.3)
	
	for card in card_collection.cards_in_collection:
		tween.parallel().tween_property(card, "position:y", card.position.y + 1080, 0.3)
		
	await tween.finished
	in_collection = false
	
func _on_back_button_pressed() -> void:
	collection_down()


func _on_card_slot_mouse_entered() -> void:
	%CardSlot.scale = Vector2(1.05, 1.05)


func _on_card_slot_mouse_exited() -> void:
	%CardSlot.scale = Vector2(1, 1)


func _on_trash_button_pressed() -> void:
	card_editor.trash_card()

func drop_tag_description():
	var tag_description = $"../EditArea/Options/TagArea/TagDescription"
	
	$"../EditArea/Options/TagArea/TagDescription/MarginContainer/MarginContainer/DescriptionText".text = ""
	tag_description.custom_minimum_size.y = 0
	tag_description.size.y = 0
	
	if tween and tween.is_running():
		tween.kill()
	
	tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(tag_description, "custom_minimum_size:y", 300, 0.2)
	
func remove_tag_descripton():
	if tween and tween.is_running():
		tween.kill()
			
	var tag_description = $"../EditArea/Options/TagArea/TagDescription"
	
	$"../EditArea/Options/TagArea/TagDescription/MarginContainer/MarginContainer/DescriptionText".text = ""
	tag_description.custom_minimum_size.y = 0
	tag_description.size.y = 0
