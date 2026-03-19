extends Node

const REWARD_SLOT_HEIGHT = 296

signal on_scene_exit
	
func animate_reroll():
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
	
func _on_continue_button_pressed() -> void:
	on_scene_exit.emit()
