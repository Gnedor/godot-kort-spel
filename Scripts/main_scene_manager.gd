extends Node2D
@onready var camera: Camera2D = $"../Camera2D"
@onready var battle_scene_manager = $"../BattleScene".get_node("SceneManager")
@onready var shop_scene_manager = $"../ShopScene".get_node("ShopSceneManager")
@onready var card_editor_scene_manager: Control = $"../CardEditor".get_node("CardEditorSceneManager")


@onready var round_end_scene_manager = $"../EndOfRoundScreen"
@onready var select_sten: Node2D = $"../SelectSten"
@onready var menu_scene: Node2D = $"../MenuScene"
@onready var options_window: Control = $"../Camera2D/OptionsWindow"


func _ready() -> void:
	battle_scene_manager.on_scene_exit.connect(progress_game_scenes)
	shop_scene_manager.on_scene_exit.connect(progress_game_scenes)
	round_end_scene_manager.on_scene_exit.connect(progress_game_scenes)
	card_editor_scene_manager.on_scene_exit.connect(progress_game_scenes)
	
	select_sten.on_scene_exit.connect(scene_progression)
	menu_scene.on_scene_exit.connect(scene_progression)

	options_window.exit_pause.connect(pause_game)
	
	scene_progression()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func progress_game_scenes():
	Global.progress_stage()
	scene_progression()
	
func scene_progression():
	match Global.scene_name:
		"battle":
			move_to_battle_scene()
		"boss":
			move_to_battle_scene()
		"result":
			move_to_end_round_screen()
		"shop":
			move_to_shop_scene()
			Global.round += 1
		"editor":
			move_to_editor_scene()
			Global.round += 1
		"sten":
			move_to_select_scene()
		"menu":
			move_to_menu_scene()
			

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
	
func move_to_editor_scene():
	camera.position = $"../CardEditor".position
	card_editor_scene_manager.on_enter_scene()
	
	
func pause_game():
	if !Global.is_game_paused:
		Global.is_game_paused = true
		await options_window.enter_pause_anim()
	else:
		Global.is_game_paused = false
		await options_window.exit_pause_anim()
		
