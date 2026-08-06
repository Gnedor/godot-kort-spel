extends Node

const REWARD_SLOT_HEIGHT = 296

signal on_scene_exit

@onready var collection: Node2D = $"../CardCollection"
@onready var darken_screen: ColorRect = $"../DarkenScreen"
@onready var slot: NinePatchRect = $"../NinePatchRect"
@onready var deck: Node2D = $"../SpellDeck"
@onready var title: RichTextLabel = $"../Title"
@onready var continue_button: Button = $"../ContinueButton"

const SLOT_POS = Vector2(480, 360)

func _ready() -> void:
	#MainSceneManager.reward_scene_manager = self
	pass

func on_enter_scene():
	$"..".on_enter()
	if slot.position == SLOT_POS:
		slot.position.y -= 1080
		deck.position.y += 1080
		continue_button.position.y += 1080
		
	move_in_scene()
	
		
func animate_roll():
	roll(%TagRewardSlot.get_child(0))
	await Global.timer(0.2)
	
	roll(%TileRewardSlot.get_child(0))
	await Global.timer(0.2)
	
	roll(%CardRewardSlot.get_child(0))
	await Global.timer(0.2)
	
func roll(obj):
	const ROLL_SPEED = 0.05
	
	var tween = get_tree().create_tween().set_loops(10)
	tween.tween_property(obj, "position:y", obj.position.y + (REWARD_SLOT_HEIGHT * 2), ROLL_SPEED)
	tween.tween_callback(func(): obj.position.y -= REWARD_SLOT_HEIGHT * 2)
	
	await tween.finished
	
	var stop_tween = get_tree().create_tween()
	stop_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	stop_tween.tween_property(obj, "position:y", obj.position.y + REWARD_SLOT_HEIGHT, 0.5)
	
	SignalManager.emit_signal("shake_camera")
	
func _on_continue_button_pressed() -> void:
	await move_out_scene()
	on_scene_exit.emit()

func _on_deck_click(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if !(event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT):
		return
		
	if event.pressed:
		open_collection()  
		
func open_collection():
	collection.move_in_cards()
	var tween = get_tree().create_tween()
	for card in collection.cards_in_collection:
	#card.position.y += Global.window_size.y
		tween.parallel().tween_property(card, "position:y", card.position.y - Global.window_size.y, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
		
	collection.create_page_indicators()
	tween.parallel().tween_property(collection, "position", Vector2(0, 0), 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property(darken_screen, "color", Color(0.0, 0.0, 0.0, 0.7), 0.1)


func _on_back_button_pressed() -> void:
	close_collection()
	
func close_collection():
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property(collection, "position:y", 1080, 0.3)
	tween.parallel().tween_property(darken_screen, "color", Color(0.0, 0.0, 0.0, 0.0), 0.3)
	
	for card in collection.cards_in_collection:
		tween.parallel().tween_property(card, "position:y", card.position.y + Global.window_size.y, 0.3)
		
	await tween.finished
	collection.move_out_cards()
	
func move_in_scene():
	if title.visible_ratio == 1.0:
		title.visible_ratio = 0.0
	
	var tween = get_tree().create_tween()
	tween.parallel().tween_property(slot, "position:y", SLOT_POS.y, 0.3).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property(deck, "position:y", deck.position.y - 1080, 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property(continue_button, "position:y", continue_button.position.y - 1080, 0.3).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	
	await tween.finished
	
	var title_tween = get_tree().create_tween()
	title_tween.tween_property(title, "visible_ratio", 1.0, 0.3)
	AudioManager.animate_text_audio(str(title.get_text()).length(), 0.3)
	
	SignalManager.signal_emitter("shake_camera")
	
func move_out_scene():
	var label_tween = get_tree().create_tween()
	label_tween.tween_property(title, "visible_ratio", 0.0, 0.2)
	await label_tween.finished
	
	var tween = get_tree().create_tween()
	tween.parallel().tween_property(slot, "position:y", SLOT_POS.y - 1080, 0.3).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property(deck, "position:y", deck.position.y + 1080, 0.3).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property(continue_button, "position:y", continue_button.position.y + 1080, 0.3).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)

	
	await tween.finished
	
	
