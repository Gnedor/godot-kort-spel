extends Node2D

@onready var sten: Node2D = $"../sten"
@onready var deck: Node2D = $"../TroopDeck"
@onready var discard_pile: Node2D = $"../DiscardPile"
@onready var ui: Node2D = $"../CardBar"
@onready var card_slots: Node2D = $"../CardSlots"
@onready var card_manager: Node2D = $"../CardManager"
@onready var battle_manager: Node2D = $"../BattleManager"
@onready var spell_deck: Node2D = $"../SpellDeck"
@onready var round_box: ColorRect = $"../Round Box"
@onready var money_box: ColorRect = $"../Round Box/Money Box"
@onready var tiles_folder: Node2D = $"../TilesFolder"
@onready var timer: Timer = $Timer
@onready var pause_timer: Timer = $PauseTimer
@onready var fire_effect: ColorRect = $"../FireEffect"

@export var discard_audio: AudioStream
@export var text_audio: AudioStream

var battle_scene_up
var battle_scene_up_first
var battle_scene_down
var battle_scene_down_first
var can_draw : bool = false

var first_enter : bool = true

var step : int = 1
var saved_times_quota : int = 1

var cards_to_be_removed

signal on_scene_exit
signal on_scene_enter

func _ready() -> void:
	battle_manager.end_round.connect(remove_battle_scene)
	deck.cards_ready.connect(draw_first_cards)
	SignalManager.reset_game.connect(on_reset)
	
	battle_scene_up = [sten, battle_manager.get_node("TotalDamage"), round_box, money_box, tiles_folder, $"../DebuffText", $"../DebuffIcons", $"../Quota", $"../BossScreen"]
	battle_scene_up_first = [battle_manager.get_node("TotalDamage"), round_box, money_box, tiles_folder, $"../DebuffText", $"../DebuffIcons", $"../Quota", $"../BossScreen"]
	
	battle_scene_down = [deck, spell_deck, discard_pile, ui, card_slots, battle_manager.get_node("TurnCounter"), battle_manager.get_node("EndTurn"), card_manager.get_node("HandCounter"), fire_effect]
	battle_scene_down_first = [discard_pile, ui, card_slots, battle_manager.get_node("TurnCounter"), battle_manager.get_node("EndTurn"), card_manager.get_node("HandCounter"), fire_effect]
	move_battle_ui_out()
	#move_battle_ui_out()
	#await add_battle_ui()

	#deck.add_cards_on_start()
	#tiles_folder.add_tiles_on_start()
	#call_deferred("after_ready")
	
func on_enter_scene():
	on_scene_enter.emit()
	#call_deferred("after_ready")
	after_ready()
	
	$"../Quota/Quota/Label".visible = false
	await Global.timer(0.5)
	if Global.round > 1:
		card_manager.draw_cards(3, 2)
	else:
		while true:
			await Global.timer(0.1)
			if can_draw:
				card_manager.draw_cards(3, 2)
				can_draw = false
				break
				
	await display_quota()
	
	if Global.scene_name == "boss":
		await Global.timer(0.3)
		new_boss()
	
func remove_battle_scene():
	# Sequentially animate each card
	step = 1
	timer.start()
	remove_fire()
		
func _on_timer_timeout() -> void:
	if card_manager.played_cards and step == 1:
		AudioManager.play_audio(discard_audio, 0)
		var tween = get_tree().create_tween()
		tween.tween_property(card_manager.played_cards[0], "position", Vector2(2200, 300), 0.1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
		deck.cards_in_troop_deck.append(card_manager.played_cards[0])
		card_manager.played_cards.pop_front()
		
		if !card_manager.played_cards:
			step = 2
		timer.start()
		return
	else:
		step = 2
		
	if tiles_folder.played_tiles and step == 2:
		if tiles_folder.menu_up:
			tiles_folder.animate_folder_down()
			await (pause(0.15))
			
		tiles_folder.played_tiles[0].is_placed = false
		tiles_folder.tiles_in_folder.append(tiles_folder.played_tiles[0])
		tiles_folder.played_tiles.pop_front()
		await (pause(0.05))
		tiles_folder.align_tiles()
		
		if !tiles_folder.played_tiles:
			await (pause(0.15))
			tiles_folder.animate_folder_up()
			step = 3
			timer.start()
			return
		else:
			timer.start()
	else:
		step = 3
		
	if card_manager.cards_in_hand and step == 3:
		var tween = get_tree().create_tween()
		AudioManager.play_audio(discard_audio, 0)
		tween.tween_property(card_manager.cards_in_hand[0], "position", Vector2(2200, 500), 0.1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
		
		if card_manager.cards_in_hand[0].card_type != "Spell":
			deck.cards_in_troop_deck.append(card_manager.cards_in_hand[0])
		else:
			deck.cards_in_spell_deck.append(card_manager.cards_in_hand[0])
			
		card_manager.cards_in_hand.pop_front()
		card_manager.hand_counter.text = (str(card_manager.cards_in_hand.size()))
		
		if card_manager.cards_in_hand:
			timer.start()
		else:
			timer.stop()
			await remove_battle_ui()
			$"../BossScreen".animation_player.play("RESET")
		
func remove_battle_ui():
	var tween = get_tree().create_tween()
	for node in battle_scene_up:
		tween.parallel().tween_property(node, "position:y", node.position.y - 1000, 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
		
	for node in battle_scene_down:
		tween.parallel().tween_property(node, "position:y", node.position.y + 1000, 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
		
	await tween.finished
	# call_deferred("_change_scene")
	on_scene_exit.emit()
	
func add_battle_ui():
	var tween = get_tree().create_tween()
	if Global.enter_from_start:
		for node in battle_scene_down_first:
			tween.parallel().tween_property(node, "position:y", node.position.y - 1000, 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
			
		for node in battle_scene_up_first:
			tween.parallel().tween_property(node, "position:y", node.position.y + 1000, 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
		Global.enter_from_start = false
			
	else:
		for node in battle_scene_up:
			tween.parallel().tween_property(node, "position:y", node.position.y + 1000, 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
			
		for node in battle_scene_down:
			tween.parallel().tween_property(node, "position:y", node.position.y - 1000, 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
		
	await tween.finished
	
func move_battle_ui_out():
	if Global.round == 1:
		for node in battle_scene_down_first:
			node.position.y += 1000
		for node in battle_scene_up_first:
			node.position.y -= 1000
	else:
		for node in battle_scene_down:
			node.position.y += 1000
		for node in battle_scene_up:
			node.position.y -= 1000
		
func after_ready():
	await add_battle_ui()
	tiles_folder.add_tiles_on_start()
	
	await Global.timer(0.1)
	$"../TroopDeck/TroopDeckCounter".visible = true
	$"../SpellDeck/SpellDeckCounter".visible = true
	
func draw_first_cards():
	can_draw = true
	
func _change_scene():
	get_tree().change_scene_to_file("res://Scenes/end_of_round_screen.tscn")
	
func pause(duration : float) -> void:
	pause_timer.wait_time = duration
	pause_timer.start()
	await pause_timer.timeout
	
func display_quota():
	var quota_label = $"../Quota/Quota/Label"
	quota_label.visible_ratio = 0.0
	quota_label.z_index = 1001
	$"../BattleManager/DarkenBackground".z_index = 1000
	battle_manager.darken_screen()
	await Global.timer(0.5)
	
	var tween = get_tree().create_tween()
	quota_label.global_position = Vector2(807, 540)
	quota_label.scale = Vector2(3, 3)

	tween.parallel().tween_property($"../NewQuota", "visible_ratio", 1.0, 0.2)
	AudioManager.animate_text_audio(str($"../NewQuota".get_text()).length(), 0.2)
	
	tween.parallel().tween_property(quota_label, "visible_ratio", 1.0, 0.2)
	
	await Global.timer(0.5)
	var new_quota: int = 0
	
	quota_label.visible = true
	while quota_label.text != str(Global.quota):
		AudioManager.play_audio(text_audio, -20)
		new_quota += Global.quota / 20
		quota_label.text = str(new_quota)
		await Global.timer(0.01)
		
	await Global.timer(0.3)
	tween = get_tree().create_tween()
	tween.tween_property($"../NewQuota", "visible_ratio", 0.0, 0.2)
	
	await Global.timer(0.2)
	battle_manager.brighten_screen()
	
	tween = get_tree().create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property(quota_label, "position", Vector2(0, 3), 0.2)
	tween.parallel().tween_property(quota_label, "scale", Vector2(1, 1), 0.2)
	quota_label.z_index = 1
		
func on_reset():
	var quota_label = $"../Quota/Quota/Label"
	quota_label.text = "0"
	
func change_fire():
	var offset_base = 2.5
	var anim_speed_base = 2
	var offset
	var anim_speed
	
	var times_quota : int = 1
	var temp = Global.total_damage - Global.quota
	
	while temp > (Global.quota * (times_quota)):
		temp -= Global.quota * times_quota
		times_quota += 1
	
	var remainder = 0
	var multiplier = temp / (Global.quota * times_quota)
	
	offset = 1 - (offset_base * multiplier)
	anim_speed = anim_speed_base * multiplier
	
	if Global.total_damage > Global.quota:
		if multiplier == 0:
			fire_effect.material.set_shader_parameter("y_offset", 2)
		else:
			fire_effect.material.set_shader_parameter("y_offset", offset)
				
	fire_effect.material.set_shader_parameter("animation_speed", anim_speed) 
	
	if times_quota != 1:
		fire_effect.material.set_shader_parameter("background_color", fire_effect.material.get_shader_parameter("flame_color"))
	
	var new_color = hue_shift_color(fire_effect.material.get_shader_parameter("flame_color"), times_quota - 1)
	fire_effect.material.set_shader_parameter("flame_color", new_color)
	new_color = hue_shift_color(fire_effect.material.get_shader_parameter("secondary_flame_color"), times_quota - 1)
	fire_effect.material.set_shader_parameter("secondary_flame_color", new_color)
	
func hue_shift_color(color : Color, times : int):
	var h = color.h
	h = fmod((260 + 40 * times)/ 360.0 , 1.0)
	if h > 1:
		h = h - 1
	
	var new_color = Color.from_hsv(h, color.s, color.v, color.a)
	return new_color
	
func remove_fire():
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(fire_effect.material, "shader_parameter/background_color", Color(0.0, 0.0, 0.0, 1.0), 0.5)
	await Global.timer(2)
	
	fire_effect.material.set_shader_parameter("y_offset", 2)
	fire_effect.material.set_shader_parameter("animation_speed", 0) 
	
	var new_color = hue_shift_color(fire_effect.material.get_shader_parameter("flame_color"), 0)
	fire_effect.material.set_shader_parameter("flame_color", new_color)
	new_color = hue_shift_color(fire_effect.material.get_shader_parameter("secondary_flame_color"), 0)
	fire_effect.material.set_shader_parameter("secondary_flame_color", new_color)
	
func new_boss():
	$"../BossScreen".animation_player.play("Enter")
