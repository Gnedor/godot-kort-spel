extends Control

var card_scene = preload("res://Scenes/card.tscn")
var tile_scene = preload("res://Scenes/tile.tscn")
var tag_scene = preload("res://Scenes/tag.tscn")

signal on_scene_exit

var tag
var tile
var card
	
func get_rewards():
	create_new_card()
	create_new_tile()
	create_new_tag()
	reroll()
	
func create_new_tag():
	var reward_slot = %TagRewardSlot
	var new_tag = tag_scene.instantiate()
	reward_slot.add_child(new_tag)
	tag = new_tag
	new_tag.position = Vector2((reward_slot.size.x / 2) - (new_tag.size.x / 2), (reward_slot.size.y / -2) - (new_tag.size.y / 2))
	
	var tag_name = TagDatabase.TAGS.pick_random()["name"]
	new_tag.get_node("TextureRect").texture = load("res://Assets/images/Tags/" + tag_name + ".png")
	
func create_new_tile():
	var reward_slot = %TileRewardSlot
	var new_tile = tile_scene.instantiate()
	reward_slot.add_child(new_tile)
	tile = new_tile
	new_tile.position = Vector2(reward_slot.size.x / 2, reward_slot.size.y / -2)
	
	var tile_name = TileDatabase.TILES.keys().pick_random()
	new_tile.get_node("Sprite2D").texture = load("res://Assets/images/Tiles/" + tile_name + "_tile.png")
	
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
	
func reroll():
	create_new_tag()
	create_new_card()
	create_new_tile()
	
	$SceneManager.animate_reroll()
	
func _on_reroll_button_pressed() -> void:
	reroll()


func _on_tag_area_mouse_entered() -> void:
	tag.scale = Vector2(1.1, 1.1)


func _on_tile_area_mouse_entered() -> void:
	tile.hover_effect()


func _on_card_area_mouse_entered() -> void:
	card.hover_effect()
