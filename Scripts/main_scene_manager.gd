extends Node2D
@onready var camera: Camera2D = $"../Camera2D"
@onready var battle_scene: Node2D = $"../BattleScene"
@onready var battle_scene_manager = $"../BattleScene".get_node("SceneManager")
@onready var shop_scene: Node2D = $"../ShopScene"
@onready var shop_scene_manager = shop_scene.get_node("ShopSceneManager")
@onready var card_editor: Control = $"../CardEditor"
@onready var card_editor_scene_manager: Control = card_editor.get_node("CardEditorSceneManager")
@onready var reward_scene: Control = $"../RewardScene"
@onready var reward_scene_manager: Node = reward_scene.get_node("SceneManager")

@onready var round_end_scene = $"../EndOfRoundScreen"
@onready var select_sten: Node2D = $"../SelectSten"
@onready var menu_scene: Node2D = $"../MenuScene"
@onready var options_window: Control = $"../Camera2D/OptionsWindow"


func _ready() -> void:
	battle_scene_manager.on_scene_exit.connect(progress_game_scenes)
	shop_scene_manager.on_scene_exit.connect(progress_game_scenes)
	round_end_scene.on_scene_exit.connect(progress_game_scenes)
	card_editor_scene_manager.on_scene_exit.connect(progress_game_scenes)
	reward_scene_manager.on_scene_exit.connect(progress_game_scenes)
	
	select_sten.on_scene_exit.connect(scene_progression)
	menu_scene.on_scene_exit.connect(scene_progression)

	options_window.exit_pause.connect(pause_game)
	
	SignalManager.reset_game.connect(move_to_battle_scene)
	
	scene_progression()
	
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
		"reward":
			move_to_reward_scene()
			Global.round += 1

#------------------------v MENY SCENER v------------------------#

		"sten":
			move_to_select_scene()
		"menu":
			move_to_menu_scene()
			

func move_to_battle_scene():
	camera.position = battle_scene.position
	battle_scene_manager.on_enter_scene()
	
func move_to_shop_scene():
	camera.position = shop_scene.position
	shop_scene_manager.on_enter_scene()
	
func move_to_end_round_screen():
	camera.position = round_end_scene.position
	round_end_scene.on_enter_scene()
	
func move_to_select_scene():
	camera.position = select_sten.position
	select_sten.on_enter_scene()
	
func move_to_menu_scene():
	camera.position = menu_scene.position
	menu_scene.on_enter_scene()
	
func move_to_editor_scene():
	camera.position = card_editor.position
	card_editor_scene_manager.on_enter_scene()

func move_to_reward_scene():
	camera.position = reward_scene.position
	reward_scene_manager.on_enter_scene()
	
	
func pause_game():
	if !Global.is_game_paused:
		Global.is_game_paused = true
		await options_window.enter_pause_anim()
	else:
		Global.is_game_paused = false
		await options_window.exit_pause_anim()
		
