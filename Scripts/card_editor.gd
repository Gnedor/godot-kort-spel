extends Control

@onready var card_collection: Node2D = $CardCollection

var tween

func animate_card_slot(state : String):
	tween = get_tree().create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
	if state == "grow":
		tween.tween_property($CardSlot/NinePatchRect/TextureRect, "scale", Vector2(1.05, 1.05), 0.1)
	else:
		tween.tween_property($CardSlot/NinePatchRect/TextureRect, "scale", Vector2(1.0, 1.0), 0.1)

func _on_button_mouse_entered() -> void:
	tween = get_tree().create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(%CardSlot, "scale", Vector2(1.05, 1.05), 0.1)

func _on_button_mouse_exited() -> void:
	tween = get_tree().create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(%CardSlot, "scale", Vector2(1.0, 1.0), 0.1)


func _on_card_slot_button_down() -> void:
	tween = get_tree().create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(%CardSlot, "scale", Vector2(1.02, 1.02), 0.1)


func _on_card_slot_button_up() -> void:
	collection_up()
	tween = get_tree().create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(%CardSlot, "scale", Vector2(1.08, 1.08), 0.1)
	tween.tween_property(%CardSlot, "scale", Vector2(1.0, 1.0), 0.1)

func collection_up():
	tween = get_tree().create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "position:y", -1080, 0.3)
	
func collection_down():
	tween = get_tree().create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "position:y", 0, 0.3)

func _on_back_button_pressed() -> void:
	card_collection.move_in_cards()
	collection_down()
