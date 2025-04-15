extends Node2D

@onready var shop_scene: Node2D = $"../.."
@onready var back_button: Button = $Back
@onready var money_label: Label = $ColorRect2/ColorRect/ColorRect/Label2
@onready var trash_card: Node2D = $TrashCard
@onready var trash_button: Button = $TrashButton
@onready var trash_label: Label = $TrashButton/Label
@onready var back_label: Label = $Back/Label
@onready var tag_folder: NinePatchRect = $TagButton/TagFolder
@onready var h_box_container: HBoxContainer = $TagButton/TagFolder/NinePatchRect/HBoxContainer
@onready var tag_description: MarginContainer = $Description

signal back_pressed
signal trash_pressed

var selected_card
var trash_cost : int = 5
var tag_folder_down_state : bool = false
var dragged_tag : Control
var stored_tag_pos : Vector2
var hovered_tag : Node
var offset : Vector2
var tags = []

func _ready() -> void:
	tags = h_box_container.get_children()

func _process(delta: float) -> void:
	align_tag_hover()
	money_label.text = str(Global.total_money) + "$"
	if dragged_tag:
		dragged_tag.global_position = Vector2(
			clamp(get_global_mouse_position().x - offset.x * dragged_tag.scale.x, 3840, 5680), 
			clamp(get_global_mouse_position().y - offset.y * dragged_tag.scale.y, 0, Global.window_size.y))

func _on_back_pressed() -> void:
	back_pressed.emit(shop_scene.selected_card)
	tag_folder_up()

func _on_trash_button_pressed() -> void:
	if shop_scene.selected_card:
		if Global.total_money >= trash_cost:
			trash_button.disabled = true
			trash_pressed.emit(shop_scene.selected_card)
			back_button.disabled = true
			Global.total_money -= trash_cost
			trash_cost += 3
			
func on_enter():
	trash_button.disabled = false
	back_button.disabled = false
	visible = true
	
func update_labels():
	trash_label.text = "Trash Card\n\n" + str(trash_cost) + "$"  

func _on_back_button_down() -> void:
	back_label.position.y += 2

func _on_back_button_up() -> void:
	back_label.position.y -= 2


func _on_tag_button_pressed() -> void:
	if tag_folder_down_state:
		tag_folder_up()
	else:
		tag_folder_down()

func tag_folder_down():
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tag_folder.visible = true
	tween.parallel().tween_property(tag_folder, "position:y", 120, 0.2)
	await tween.finished
	toggle_collision(false)
	tag_folder_down_state = true
	
func tag_folder_up():
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property(tag_folder, "position:y", 0, 0.2)
	toggle_collision(true)
	await tween.finished
	tag_folder.visible = false
	tag_folder_down_state = false
		
func align_tag():
	dragged_tag.scale = Vector2(1.0, 1.0)
	var duration = find_duration(dragged_tag.position, stored_tag_pos, 6000)
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(dragged_tag, "position", stored_tag_pos, duration)
	
func find_duration(pos1, pos2, speed):
	var distance = pos1.distance_to(pos2)
	var duration = distance / speed
	return duration
	
func align_tag_hover():
	for tag in h_box_container.get_children():
		if tag == hovered_tag:
			tag.z_index = 100
			if tag != dragged_tag:
				tag.scale = Vector2(1.1, 1.1)
		else:
			tag.z_index = 1
			tag.scale = Vector2(1.0, 1.0)

func add_tags():
	for tag in tags:
		tag.visible = false
	var i : int = 0
	for tag_name in Global.stored_tags:
		var tag = tags[i]
		tag.visible = true
		tag.get_node("TextureRect").texture = load("res://Assets/images/Tags/" + tag_name + ".png")
		tag.name = tag_name + str(i)
		i += 1
		
func toggle_collision(toggle : bool):
	for tag in tags:
		if tag.visible == true:
			tag.get_node("Area2D/CollisionShape2D").disabled = toggle
		else:
			tag.get_node("Area2D/CollisionShape2D").disabled = true
			
func display_tag_description():
	var name = hovered_tag.name
	name = name.left(name.length() - 1)
	tag_description.visible = true
	$Description/MarginContainer/NameLabel.text = name
	for tag in TagDatabase.TAGS:
		if tag["name"] == name:
			$Description/MarginContainer/MarginContainer/DescriptionLabel.text = "[center]" + tag["description"] + "[/center]"
	Global.color_text($Description/MarginContainer/MarginContainer/DescriptionLabel)

		
