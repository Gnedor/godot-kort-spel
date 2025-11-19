extends Control

@onready var card_collection: Node2D = $"../CardCollection"

signal on_scene_exit

var tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_continue_button_pressed() -> void:
	on_scene_exit.emit()

func _on_card_slot_button_down() -> void:
	tween = get_tree().create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(%CardSlot, "scale", Vector2(1.02, 1.02), 0.1)


func _on_card_slot_button_up() -> void:
	collection_up()
	tween = get_tree().create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(%CardSlot, "scale", Vector2(1.08, 1.08), 0.1)
	tween.tween_property(%CardSlot, "scale", Vector2(1.0, 1.0), 0.1)

func collection_up():
	card_collection.move_in_cards()
	card_collection.create_page_indicators()
	tween = get_tree().create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property($"..", "position:y", -1080, 0.3)
	for card in card_collection.cards_in_collection:
		tween.parallel().tween_property(card, "position:y", card.position.y - 1080, 0.3)
	
func collection_down():
	tween = get_tree().create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property($"..", "position:y", 0, 0.3)
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
