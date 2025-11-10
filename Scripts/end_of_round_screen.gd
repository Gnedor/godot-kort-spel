extends Node2D

@onready var ui: Node2D = $UI
@onready var total_damage_label: Label = $UI/Row1/ColorRect5/TotalDamageLabel
@onready var quota_label: Label = $UI/Row2/ColorRect5/QuotaLabel
@onready var money_label: Label = $UI/Row3/ColorRect4/MoneyLabel
@onready var equals_label: Label = $UI/Row3/ColorRect5/EqualsLabel
@onready var total_money: Label = $UI/Row3/ColorRect6/TotalMoney
@onready var round_label: Label = $UI/NinePatchRect/RoundLabel
@onready var continue_label: Label = $UI/Button/Label
@onready var continue_button: Button = $UI/Button
@onready var fail_screen: Node2D = $FailScreen
@onready var tag_texture: TextureRect = $UI/NinePatchRect3/NinePatchRect/NinePatchRect2/TextureRect
@onready var stage_timeline = $StageTimeline

var base_money = 3
var max_money = 50

signal on_scene_enter
signal on_scene_exit

var tags = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func on_enter_scene():
	continue_button.disabled = true
	ui.visible = true
	ui.position = Vector2(960, 504)
	round_label.text = "Round " + str(Global.round) + " Results"
	total_damage_label.visible_ratio = 0.0
	quota_label.visible_ratio = 0.0
	money_label.visible_ratio = 0.0
	equals_label.visible_ratio = 0.0
	total_money.visible_ratio = 0.0
	tag_texture.visible = false
	for tag in TagDatabase.TAGS:
		tags.append(tag["name"])
		
	start_end_screen()
	on_scene_enter.emit()
	
	view_timeline()
	
func start_end_screen():
	ui.scale = Vector2(1.7, 1.7)
	await animate_screen_scale()
	await get_tree().create_timer(0.2).timeout

	Global.round_number(total_damage_label, Global.total_damage)
	Global.round_number(quota_label, Global.quota)
	money_label.text = str(Global.base_money) + "$"
	var multiplier : float = Global.total_damage / Global.quota
	Global.round_number(equals_label, (floor(multiplier / 0.5) * 0.5))
	var money_gain = Global.base_money * floor(multiplier / 0.5) * 0.5
	if money_gain > max_money:
		money_gain = max_money
	total_money.text = str(money_gain) + "$"
	
	var labels_to_be_updated = [total_damage_label, quota_label, money_label, equals_label, total_money]
	
	for label in labels_to_be_updated:
		await add_text(label)
		
	Global.total_money += money_gain
	
	if Global.total_damage >= Global.quota:
		await get_tag()
		continue_button.disabled = false
		continue_button.modulate = Color(1, 1, 1)
	else:
		var tween = get_tree().create_tween()
		tween.tween_property(fail_screen, "global_position:y", Global.window_size.y / 2, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
		await tween.finished
		ui.visible = false
	
func animate_screen_scale():
	var tween = get_tree().create_tween()
	tween.tween_property(ui, "scale", Vector2(1.5, 1.5), 0.05)
	await tween.finished
	
func _on_button_pressed() -> void:
	await move_off_screen()
	on_scene_exit.emit()
	Global.quota = Global.round * 40
	
func _on_button_button_down() -> void:
	continue_label.position.y += 3

func _on_button_button_up() -> void:
	continue_label.position.y -= 3
	
func add_text(label):
	var tween = get_tree().create_tween()
	tween.tween_property(label, "visible_ratio", 1.0, 0.1)
	AudioManager.animate_text_audio(str(label.get_text()).length(), 0.1)
	await tween.finished
	
func move_off_screen():
	var tween = get_tree().create_tween()
	tween.parallel().tween_property(ui, "position:y", ui.position.y + 1500, 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property($StageTimeline, "position:y", -200, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	
func _change_scene(scene_path : String):
	Global.total_damage = 0
	get_tree().change_scene_to_file(scene_path)
	
func get_tag():
	if Global.stored_tags.size() < 5:
		var random_num = randi() % tags.size()
		tag_texture.texture = load("res://Assets/images/Tags/" + tags[random_num] + ".png")
		
		tag_texture.scale = Vector2(4.0, 4.0)
		tag_texture.visible = true
		var tween = get_tree().create_tween()
		tween.tween_property(tag_texture, "scale", Vector2(3.0, 3.0), 0.2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		Global.stored_tags.append(tags[random_num])

func view_timeline():
	stage_timeline.position.y = -100
	stage_timeline.adjust_timeline()
	
	await Global.timer(0.5)
	var tween = get_tree().create_tween()
	tween.tween_property(stage_timeline, "position:y", 0, 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
	await Global.timer(0.5)
	stage_timeline.next_stage()
	
