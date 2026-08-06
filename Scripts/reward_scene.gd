extends Control

@onready var scene_manager: Node = $SceneManager

var card_scene = preload("res://Scenes/card.tscn")
var tile_scene = preload("res://Scenes/tile.tscn")
var tag_scene = preload("res://Scenes/tag.tscn")

var card_manager_scene
var tiles_folder_scene

signal on_scene_exit

var tag
var tile
var card

var hovered_reward
	
@onready var tag_label: Label = $NinePatchRect/HBoxContainer/RewardBox1/TagName/Label
@onready var tile_label: Label = $NinePatchRect/HBoxContainer/RewardBox2/TileName/Label
@onready var card_label: Label = $NinePatchRect/HBoxContainer/RewardBox3/CardName/Label
	
func on_enter():
	remove_rewards()
	card_manager_scene = get_parent().get_node("BattleScene").get_node("CardManager")
	tiles_folder_scene = get_parent().get_node("BattleScene").get_node("TilesFolder")
	$NinePatchRect/Control/SlotButton.disabled = false

func get_rewards():

	create_new_card()
	create_new_tile()
	create_new_tag()
	roll_rewards()
	
func create_new_tag():
	var reward_slot = %TagRewardSlot
	var new_tag = tag_scene.instantiate()
	reward_slot.add_child(new_tag)
	tag = new_tag
	new_tag.position = Vector2((reward_slot.size.x / 2) - (new_tag.size.x / 2), (reward_slot.size.y / -2) - (new_tag.size.y / 2))
	
	var tag_name = TagDatabase.TAGS.pick_random()["name"]
	new_tag.get_node("TextureRect").texture = load("res://Assets/images/Tags/" + tag_name + ".png")
	new_tag.set_description(tag_name)
	change_reward_label(tag_label, tag_name)
	
func create_new_tile():
	var reward_slot = %TileRewardSlot
	var new_tile = tile_scene.instantiate()
	reward_slot.add_child(new_tile)
	tile = new_tile
	new_tile.position = Vector2(reward_slot.size.x / 2, reward_slot.size.y / -2)
	
	var tile_name = TileDatabase.TILES.keys().pick_random()
	new_tile.set_details(tile_name)
	change_reward_label(tile_label, tile_name)
	
func create_new_card():
	var reward_slot = %CardRewardSlot
	var new_card = card_scene.instantiate()
	reward_slot.add_child(new_card)
	card = new_card
	new_card.position = Vector2(reward_slot.size.x / 2, reward_slot.size.y / -2)
	
	var card_name = CardDatabase.CARDS.keys().pick_random()
	new_card.set_base_stats(card_name)
	new_card.adjust_card_details()
	new_card.update_card()
	new_card.z_index = 0
	change_reward_label(card_label, card_name)
	
func change_reward_label(label : Label, new_text : String):
	var tween = get_tree().create_tween()
	tween.tween_property(label, "visible_ratio", 0, 0.2)
	
	await tween.finished
	
	label.text = new_text
	var tween2 = get_tree().create_tween()
	tween2.tween_property(label, "visible_ratio", 1.0, 0.2)
	
func roll_rewards():
	$SceneManager.animate_roll()
	
func remove_old_rewards(slot : ColorRect, reference):
	var to_remove = []
	for obj in slot.get_children():
		if obj != reference:
			to_remove.append(obj)
			
	for obj in to_remove:
		slot.remove_child(obj)
		obj.queue_free()

func _on_tag_reward_slot_mouse_entered() -> void:
	if tag:
		hovered_reward = tag
		$NinePatchRect/HBoxContainer/RewardBox1/HoverBorder.visible = true
		tag.hover()
		tag.show_description()
	
func _on_tag_reward_slot_mouse_exited() -> void:
	if tag:
		hovered_reward = null
		$NinePatchRect/HBoxContainer/RewardBox1/HoverBorder.visible = false
		tag.hover_off()
		tag.hide_description()

func _on_tile_reward_slot_mouse_entered() -> void:
	if tile:
		hovered_reward = tile
		$NinePatchRect/HBoxContainer/RewardBox2/HoverBorder.visible = true
		tile.hover_effect()

func _on_tile_reward_slot_mouse_exited() -> void:
	if tile:
		hovered_reward = null
		$NinePatchRect/HBoxContainer/RewardBox2/HoverBorder.visible = false
		tile.hover_off_effect()

func _on_card_reward_slot_mouse_entered() -> void:
	if card:
		hovered_reward = card
		$NinePatchRect/HBoxContainer/RewardBox3/HoverBorder.visible = true
		card.hover_effect()

func _on_card_reward_slot_mouse_exited() -> void:
	if card:
		hovered_reward = null
		$NinePatchRect/HBoxContainer/RewardBox3/HoverBorder.visible = false
		card.hover_off_effect()
		
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and Global.scene_name == "reward" and !Global.is_game_paused:
		if !hovered_reward:
			return
		match hovered_reward:
			card:
				Global.stored_cards.append(card)
				card.reparent(card_manager_scene)
				card.visible = false
				card = null
				card_label.text = ""
				$NinePatchRect/HBoxContainer/RewardBox3/HoverBorder.visible = false
			tile:
				Global.stored_tiles.append(tile)
				tile.reparent(tiles_folder_scene)
				tile.visible = false
				tile = null
				tile_label.text = ""
				$NinePatchRect/HBoxContainer/RewardBox2/HoverBorder.visible = false
			tag:
				Global.stored_tags.append(tag_label.text) #kommer inte på ett bättre sätt, kanske metadata men jag orkar inte
				tag.visible = false
				%TagRewardSlot.remove_child(tag)
				tag.queue_free()
				tag = null
				tag_label.text = ""
				$NinePatchRect/HBoxContainer/RewardBox1/HoverBorder.visible = false
			_: return
			
func slot_screen_shake():
	SignalManager.signal_emitter("shake_camera")

func _on_slot_button_pressed() -> void:
	$NinePatchRect/Control/SlotButton.disabled = true
	get_rewards()
	$SlotAnimationPlayer.play("pull arm")
	
func remove_rewards():
	if card:
		card.queue_free()
		card = null
	if tile:
		tile.queue_free()
		tile = null
	if tag:
		tag.queue_free()
		tag = null
