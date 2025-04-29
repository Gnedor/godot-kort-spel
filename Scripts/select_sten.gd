extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$DeckPreview.continue_clicked.connect(move_in)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func move_in():
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property(self, "position", Vector2(-1920, 1080), 0.2)
	
func move_out():
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property(self, "position", Vector2(-1920, 0), 0.2)
	

func _on_back_button_pressed() -> void:
	move_out()
	$DeckPreview.move_deck_in()
