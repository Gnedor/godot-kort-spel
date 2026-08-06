extends Control
class_name Tag

@onready var description: MarginContainer = $Description
@onready var texture_rect: TextureRect = $TextureRect
@onready var collision_shape: CollisionShape2D = $Area2D/CollisionShape2D

signal on_hover
signal on_hover_off

func _on_area_2d_mouse_entered() -> void:
	hover()

func _on_area_2d_mouse_exited() -> void:
	hover_off()
	
func hover():
	texture_rect.scale = Vector2(4.8, 4.8)
	on_hover.emit(self)
	
func hover_off():
	texture_rect.scale = Vector2(4.0, 4.0)
	on_hover_off.emit()
	
func disable_collision(state : bool):
	$Area2D/CollisionShape2D.disabled = state
	
func set_description(name : String):
	description.name_label.text = "[center]" + name + "[/center]"
	for tag in TagDatabase.TAGS:
		if tag["name"] == name:
			description.description_label.text = tag["description"]
			Global.color_text(description.description_label)
			return
			
	print("hittar inte tag description" + name)
	
func show_description():
	description.visible = true

func hide_description():
	description.visible = false
