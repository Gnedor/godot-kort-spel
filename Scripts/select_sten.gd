extends Node2D
@onready var battle_scene: Node2D = $"../BattleScene"
@onready var texture_rect: TextureRect = $"../TextureRect"

var shapes = ["Sten", "Square", "Pentagon", "Circle", "Smiley", "Golden sten", ]
var difficulty : int = 0

signal on_scene_exit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$DeckPreview.continue_clicked.connect(move_in)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func on_enter_scene():
	$DeckPreview.move_in()
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property($"../TextureRect", "modulate", Color(0.755, 0.755, 0.755), 0.4)
	
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
	AudioManager.play_click_sound()
	difficulty += 1
	change_sten()
	$NinePatchRect3/Button_left.disabled = false
	if difficulty + 1 >= shapes.size():
		$NinePatchRect3/Button_right.disabled = true
	
func _on_button_left_pressed() -> void:
	AudioManager.play_click_sound()
	difficulty -= 1
	change_sten()
	$NinePatchRect3/Button_right.disabled = false
	if difficulty <= 0:
		$NinePatchRect3/Button_left.disabled = true


func _on_play_button_pressed() -> void:
	Global.enter_from_start = true
	battle_scene.get_node("sten/Sprite2D").texture = load("res://Assets/images/Stenar/" + shapes[difficulty] + ".png")
	battle_scene.get_node("TroopDeck/Sprite2D").texture = $DeckPreview.get_node("Deck/Sprite2D").texture
	battle_scene.get_node("SpellDeck/Sprite2D").texture = $DeckPreview.get_node("Deck/Sprite2D2").texture
	
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property($NinePatchRect3, "position", Vector2(552, 1080 - 696), 0.2)
	tween.parallel().tween_property($"../TextureRect", "modulate", Color(0, 0, 0), 0.4)
	
	await tween.finished
	#Global.scene_name = "battle"
	Global.scene_name = Global.stage_list[0]
	on_scene_exit.emit()

func _on_button_left_button_down() -> void:
	$NinePatchRect3/Button_left/Arrow_left.position.y += 3

func _on_button_left_button_up() -> void:
	$NinePatchRect3/Button_left/Arrow_left.position.y -= 3
	
	
func _on_button_right_button_down() -> void:
	$NinePatchRect3/Button_right/Arrow_right.position.y += 3

func _on_button_right_button_up() -> void:
	$NinePatchRect3/Button_right/Arrow_right.position.y -= 3
	

func _on_back_button_button_down() -> void:
	$NinePatchRect3/BackButton/Label.position.y += 3

func _on_back_button_button_up() -> void:
	$NinePatchRect3/BackButton/Label.position.y -= 3
	
	
func _on_play_button_button_down() -> void:
	$NinePatchRect3/PlayButton/Label.position.y += 3

func _on_play_button_button_up() -> void:
	$NinePatchRect3/PlayButton/Label.position.y -= 3
