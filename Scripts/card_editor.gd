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


func adjust_description(card):
	var description_label = $EditArea/Control/MarginContainer/MarginContainer/MarginContainer/RichTextLabel
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
	
	var anim_time = description_label.get_line_count() * 0.5
	
	name_label.visible_ratio = 0.0
	description_label.visible_ratio = 0.0
	
	tween.tween_property(name_label, "visible_ratio", 1.0 , 0.2)
	AudioManager.animate_text_audio(str(name_label.get_text()).length(), 0.2)
	await tween.finished
	

	print(anim_time)
	tween = get_tree().create_tween()
	tween.tween_property(description_label, "visible_ratio", 1.0, anim_time)
	AudioManager.animate_text_audio(str(description_label.get_text()).length(), anim_time)
	
