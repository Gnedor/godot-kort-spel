extends Node2D

@onready var shop_scene: Node2D = $"../.."
@onready var back_button: Button = $Back
@onready var money_label: Label = $ColorRect2/ColorRect/ColorRect/Label2
@onready var trash_card: Node2D = $TrashCard
@onready var trash_button: Button = $TrashButton
@onready var trash_label: Label = $TrashButton/Label
@onready var back_label: Label = $Back/Label
@onready var tag_folder: NinePatchRect = $TagButton/TagFolder

signal back_pressed
signal trash_pressed

var selected_card
var trash_cost : int = 5

func _process(delta: float) -> void:
	money_label.text = str(Global.total_money) + "$"

func _on_back_pressed() -> void:
	back_pressed.emit(shop_scene.selected_card)

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
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	
	tween.parallel().tween_property(tag_folder, "position:y", 128, 0.2)
