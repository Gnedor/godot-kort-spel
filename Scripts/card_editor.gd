extends Control

@onready var scene_manager: Control = $CardEditorSceneManager

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		var card = $CardCollection.check_for_card()
		if !card:
			return
			
		scene_manager.collection_down()
		await Global.timer(0.5)
		
		adjust_description(card)
		card.global_position = %CardPoint.global_position
		card.visible = true
		if card.card_type != "Spell":
			card.stat_display.visible = true


func adjust_description(card):
	var description_label = $EditArea/Control/MarginContainer/MarginContainer/MarginContainer/RichTextLabel
	$EditArea/Control/Name/MarginContainer/NameLabel.text = card.card_name
	description_label.text = "[center]" + str(CardDatabase.CARDS[card.card_name][3])
	Global.color_text(description_label)
