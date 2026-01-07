extends Control

@onready var scene_manager: Control = $CardEditorSceneManager

var stored_card

func _input(event):
	if Global.scene_name != "editor":
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and $CardEditorSceneManager.in_collection:
		var card = $CardCollection.check_for_card()
		if !card or card == stored_card:
			return
		
		$CardEditorSceneManager.in_collection = false
		if stored_card:
			$CardCollection.cards_in_collection.append(stored_card)
		stored_card = card

		scene_manager.collection_down()
		await Global.timer(0.5)
		
		adjust_description(card)
		card.global_position = %CardPoint.global_position
		card.visible = true
		card.scale = Vector2(1.2, 1.2)
		var tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
		tween.tween_property(card, "scale", Vector2(1.0, 1.0), 0.1)


func adjust_description(card):
	var description_label = %DescriptionText
	var name_label = $EditArea/Control/Name/MarginContainer/NameLabel
	name_label.text = card.card_name
	
	description_label.text = "[center]" + str(CardDatabase.CARDS[card.card_name][3])
	Global.color_text(description_label)
	
	if card.card_type != "Spell":
		$EditArea/Control/StatDisplay/AttackLabel.text = str(card.attack)
		$EditArea/Control/StatDisplay/ActionsLabel.text = str(card.actions)
	else:
		$EditArea/Control/StatDisplay/AttackLabel.text = ""
		$EditArea/Control/StatDisplay/ActionsLabel.text = ""
	
	var image_path = "res://Assets/images/ActionTypes/" + card.card_type + "_type.png"
	%CardType.texture = load(image_path)
	
	var tween = get_tree().create_tween()
	
	var anim_time = get_anim_time(description_label)
	
	name_label.visible_ratio = 0.0
	description_label.visible_ratio = 0.0
	
	if card.trait_1:
		%"Trait 1".visible = true
		adjust_trait_description(%Trait1Name, %Trait1Description, card.trait_1)
	else: 
		%"Trait 1".visible = false
		
	if card.trait_2:
		%"Trait 2".visible = true
		adjust_trait_description(%Trait2Name, %Trait2Description, card.trait_1)
	else:
		%"Trait 2".visible = false
	
	tween.tween_property(name_label, "visible_ratio", 1.0 , 0.2)
	AudioManager.animate_text_audio(str(name_label.get_text()).length(), 0.2)
	await tween.finished
	
	tween = get_tree().create_tween()
	tween.tween_property(description_label, "visible_ratio", 1.0, anim_time)
	AudioManager.animate_text_audio(str(description_label.get_text()).length(), anim_time)
	
func get_anim_time(label):
	var anim_time = label.get_line_count() * 0.5
	return anim_time
	
func adjust_trait_description(name_label, description_label, trait_name):
	name_label.text = trait_name
	for tag in TagDatabase.TAGS:
		if tag["name"] == trait_name:
			description_label.text = tag["description"]
	Global.color_text(description_label)
	Global.color_text(name_label)
	name_label.text = "[center]" + name_label.text
	
func trash_card():
	if stored_card:
		await play_trash_animation()
		stored_card.free()
		SignalManager.signal_emitter("removed_card")
		stored_card = null
	
func play_trash_animation():
	$TrashCard.get_node("AnimationPlayer").play("trash_card_anim")
	await Global.timer(0.1667)
	stored_card.visible = false
