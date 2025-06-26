extends Node2D
@onready var camera: Camera2D = $"../Camera2D"
@onready var battle_scene_manager = $"../BattleScene".get_node("SceneManager")
@onready var shop_scene_manager = $"../ShopScene".get_node("ShopSceneManager")
@onready var round_end_scene_manager = $"../EndOfRoundScreen"
@onready var select_sten: Node2D = $"../SelectSten"
@onready var menu_scene: Node2D = $"../MenuScene"

func _ready() -> void:
	battle_scene_manager.on_scene_exit.connect(scene_progression)
	shop_scene_manager.on_scene_exit.connect(scene_progression)
	round_end_scene_manager.on_scene_exit.connect(scene_progression)
	select_sten.on_scene_exit.connect(scene_progression)
	menu_scene.on_scene_exit.connect(scene_progression)
	
	scene_progression()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func scene_progression():
	match Global.scene_index:
		0:
			move_to_battle_scene()
			Global.scene_index = 1
		1:
			move_to_end_round_screen()
			Global.scene_index = 2
		2:
			move_to_shop_scene()
			Global.scene_index = 0
			Global.round += 1
		-1:
			move_to_select_scene()
			Global.scene_index = 0
		-2:
			move_to_menu_scene()
			Global.scene_index = -1
			

func move_to_battle_scene():
	camera.position = $"../BattleScene".position
	battle_scene_manager.on_enter_scene()
	
func move_to_shop_scene():
	camera.position = $"../ShopScene".position
	shop_scene_manager.on_enter_scene()
	
func move_to_end_round_screen():
	camera.position = $"../EndOfRoundScreen".position
	round_end_scene_manager.on_enter_scene()
	
func move_to_select_scene():
	camera.position = $"../SelectSten".position
	select_sten.on_enter_scene()
	
func move_to_menu_scene():
	camera.position = $"../MenuScene".position
	menu_scene.on_enter_scene()
	
	
	
