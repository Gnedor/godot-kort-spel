extends Control

@onready var description: MarginContainer = $Description

func _ready() -> void:
	adjust_details("STOP")

func _on_area_2d_mouse_entered() -> void:
	description.visible = true

func _on_area_2d_mouse_exited() -> void:
	description.visible = false

func adjust_details(boss_name : String):
	change_image(boss_name)
	description.name_label.text = "[center]" + boss_name
	description.description_label.text = "[center]" + str(BossDatabase.BOSS_DESCRIPTIONS[boss_name][0])
	$"../BossDetailScreen/BossNameLabel".text = boss_name
	$"../BossDetailScreen/DescriptionLabel".text = BossDatabase.BOSS_DESCRIPTIONS[boss_name][0]
	
func change_image(name):
	var img_path = "res://Assets/images/BossIcons/" + name + ".png"
	var texture = load(img_path)
	$BossIcon.texture = texture
