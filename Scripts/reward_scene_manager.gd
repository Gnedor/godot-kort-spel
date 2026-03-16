extends Node

var card_scene = preload("res://Scenes/card.tscn")
var tile_scene = preload("res://Scenes/tile.tscn")
var tag_scene = preload("res://Scenes/tag.tscn")

const REWARD_SLOT_HEIGHT = 296

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func get_rewards():
	create_new_card()
	create_new_tile()
	create_new_tag()
	reroll()
	
func create_new_tag():
	var reward_slot = %TagRewardSlot
	var new_tag = tag_scene.instantiate()
	reward_slot.add_child(new_tag)
	new_tag.position = Vector2((reward_slot.size.x / 2) - (new_tag.size.x / 2), (reward_slot.size.y / -2) - (new_tag.size.y / 2))
	
	var tag_name = TagDatabase.TAGS.pick_random()["name"]
	new_tag.get_node("TextureRect").texture = load("res://Assets/images/Tags/" + tag_name + ".png")
	
func create_new_tile():
	var reward_slot = %TileRewardSlot
	var new_tile = tile_scene.instantiate()
	reward_slot.add_child(new_tile)
	new_tile.position = Vector2(reward_slot.size.x / 2, reward_slot.size.y / -2)
	
	var tile_name = TileDatabase.TILES.keys().pick_random()
	new_tile.get_node("Sprite2D").texture = load("res://Assets/images/Tiles/" + tile_name + "_tile.png")
	
func create_new_card():
	var reward_slot = %CardRewardSlot
	var new_card = card_scene.instantiate()
	reward_slot.add_child(new_card)
	new_card.position = Vector2(reward_slot.size.x / 2, reward_slot.size.y / -2)
	
	var card_name = CardDatabase.CARDS.keys().pick_random()
	new_card.adjust_card_details()
	new_card.set_base_stats(card_name)
	new_card.update_card()
	new_card.z_index = 0
	
func reroll():
	create_new_tag()
	create_new_card()
	create_new_tile()
	
	for tag in %TagRewardSlot.get_children():
		var tag_tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
		tag_tween.parallel().tween_property(tag, "position:y", tag.position.y + REWARD_SLOT_HEIGHT, 0.3)
	await Global.timer(0.1)
	
	for tile in %TileRewardSlot.get_children():
		var tile_tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
		tile_tween.parallel().tween_property(tile, "position:y", tile.position.y + REWARD_SLOT_HEIGHT, 0.3)
	await Global.timer(0.1)
	
	for card in %CardRewardSlot.get_children():
		var card_tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
		card_tween.parallel().tween_property(card, "position:y", card.position.y + REWARD_SLOT_HEIGHT, 0.3)
	


func _on_reroll_button_pressed() -> void:
	reroll()
