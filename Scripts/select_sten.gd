extends Node2D
@onready var battle_scene: Node2D = $"../BattleScene"


var shapes = ["Sten", "Square", "Triangle", "Smiley", "Golden sten", ]
var difficulty : int = 0

signal on_scene_exit

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

func change_sten():
		$NinePatchRect3/NinePatchRect/ShapeLabel.text = shapes[difficulty]
		var image_path = "res://Assets/images/Stenar/" + shapes[difficulty] + ".png"
		$sten.get_node("Sprite2D").texture = load(image_path)

func _on_button_right_pressed() -> void:
	difficulty += 1
	change_sten()
	$NinePatchRect3/Button_left.disabled = false
	if difficulty + 1 >= shapes.size():
		$NinePatchRect3/Button_right.disabled = true
	
func _on_button_left_pressed() -> void:
	difficulty -= 1
	change_sten()
	$NinePatchRect3/Button_right.disabled = false
	if difficulty <= 0:
		$NinePatchRect3/Button_left.disabled = true


func _on_play_button_pressed() -> void:
	battle_scene.get_node("sten/Sprite2D").texture = load("res://Assets/images/Stenar/" + shapes[difficulty] + ".png")
	battle_scene.get_node("TroopDeck/Sprite2D").texture = $DeckPreview.get_node("Deck/Sprite2D").texture
	battle_scene.get_node("SpellDeck/Sprite2D").texture = $DeckPreview.get_node("Deck/Sprite2D2").texture
	
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property($NinePatchRect3, "position", Vector2(552, 1080 - 696), 0.2)
	tween.parallel().tween_property($"../TextureRect", "modulate", Color(0, 0, 0), 0.4)
	
	await tween.finished
	
	on_scene_exit.emit()
