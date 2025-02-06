extends Node2D

@onready var ui: Node2D = $UI
@onready var total_damage_label: Label = $UI/Row1/ColorRect5/TotalDamageLabel
@onready var quota_label: Label = $UI/Row2/ColorRect5/QuotaLabel
@onready var money_label: Label = $UI/Row3/ColorRect4/MoneyLabel
@onready var equals_label: Label = $UI/Row3/ColorRect5/EqualsLabel
@onready var total_money: Label = $UI/Row3/ColorRect6/TotalMoney
@onready var round_label: Label = $UI/ColorRect4/RoundLabel
@onready var continue_label: Label = $UI/Button/Label
@onready var button: Button = $UI/Button
@onready var fail_screen: Node2D = $FailScreen

var base_money = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ui.position = Vector2(0, 44)
	round_label.text = "Round " + str(Global.round) + " Results"
	total_damage_label.visible_ratio = 0.0
	quota_label.visible_ratio = 0.0
	money_label.visible_ratio = 0.0
	equals_label.visible_ratio = 0.0
	total_money.visible_ratio = 0.0
	start_end_screen()

func start_end_screen():
	ui.scale = Vector2(1.7, 1.7)
	await animate_screen_scale()
	await get_tree().create_timer(0.2).timeout

	total_damage_label.text = str(Global.total_damage)
	quota_label.text = str(Global.quota)
	money_label.text = str(Global.base_money) + "$"
	var multiplier : float = Global.total_damage / Global.quota
	equals_label.text = str(floor(multiplier / 0.5) * 0.5)
	var money_gain = Global.base_money * floor(multiplier / 0.5) * 0.5
	total_money.text = str(money_gain) + "$"
	
	var labels_to_be_updated = [total_damage_label, quota_label, money_label, equals_label, total_money]
	
	for label in labels_to_be_updated:
		await add_text(label)
		
	Global.total_money += money_gain
	
	if Global.total_damage >= Global.quota:
		button.disabled = false
		button.modulate = Color(1, 1, 1)
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
	_change_scene("res://Scenes/shop.tscn")
	Global.round += 1
	Global.quota = Global.round * 40
	
func _on_button_button_down() -> void:
	continue_label.position.y += 2

func _on_button_button_up() -> void:
	continue_label.position.y -= 2
	
func add_text(label):
	var tween = get_tree().create_tween()
	tween.tween_property(label, "visible_ratio", 1.0, 0.1)
	await tween.finished
	
func move_off_screen():
	var tween = get_tree().create_tween()
	tween.parallel().tween_property(ui, "position:y", ui.position.y + 1000, 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	
func _change_scene(scene_path : String):
	Global.total_damage = 0
	get_tree().change_scene_to_file(scene_path)
