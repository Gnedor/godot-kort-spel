extends Node2D

var cardLabel := preload("res://Scenes/CardLabel.tscn")
var show_card_count : int = 0
@onready var card: Node2D = $Card

var deck_index : int = 0

signal continue_clicked 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_card_labels("Starter_deck")
	connect_signals()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func connect_signals():
	for label in $Deck/VBoxContainer/MarginContainer/MarginContainer/VBoxContainer.get_children():
		label.label_hovered.connect(show_card_info)
		label.label_hovered_off.connect(hide_card_info)
		
	for label in $Deck/VBoxContainer/MarginContainer2/MarginContainer/VBoxContainer.get_children():
		label.label_hovered.connect(show_card_info)
		label.label_hovered_off.connect(hide_card_info)
		
func show_card_info(name):
	show_card_count += 1
	adjust_card(name)
	card.visible = true
	
func hide_card_info():
	show_card_count -= 1
	# Gör så att hide card och show card inte körs i fel årdning,
	if show_card_count <= 0:
		card.visible = false
		show_card_count = 0
		
func create_card_labels(deck_name):
	for child in $Deck/VBoxContainer/MarginContainer/MarginContainer/VBoxContainer.get_children():
		child.free()
	for child in $Deck/VBoxContainer/MarginContainer2/MarginContainer/VBoxContainer.get_children():
		child.free()
		
	for card in CardDatabase[deck_name]:
		if CardDatabase.CARDS[card["name"]][2] != "Spell":
			var new_label = cardLabel.instantiate()
			$Deck/VBoxContainer/MarginContainer/MarginContainer/VBoxContainer.add_child(new_label)
			new_label.name = card["name"]
			new_label.get_node("Label").text = str(card["name"]) + " x" + str(card["amount"])
			
		else:
			var new_label = cardLabel.instantiate()
			$Deck/VBoxContainer/MarginContainer2/MarginContainer/VBoxContainer.add_child(new_label)
			new_label.name = card["name"]
			new_label.get_node("Label").text = str(card["name"]) + " x" + str(card["amount"])
			
	connect_signals()
		
func adjust_card(name):
	card.card_name = name
	card.stat_display.visible = true
	card.description.visible = true
	card.adjust_text_size()
	card.adjust_card_details()
	card.trait_1 = CardDatabase.CARDS[name][5]
	card.update_traits()
	
func move_deck_to_sides():
	continue_clicked.emit()
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property($Deck/Sprite2D, "global_position", Vector2(136 - 1920, 928), 0.2)
	tween.parallel().tween_property($Deck/Sprite2D2, "global_position", Vector2(1784 - 1920, 928), 0.2)
	tween.parallel().tween_property($Deck/Sprite2D, "scale", Vector2(3, 3), 0.2)
	tween.parallel().tween_property($Deck/Sprite2D2, "scale", Vector2(3, 3), 0.2)
	
func move_deck_in():
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property($Deck/Sprite2D, "position", Vector2(216, 256), 0.2)
	tween.parallel().tween_property($Deck/Sprite2D2, "position", Vector2(872, 256), 0.2)
	tween.parallel().tween_property($Deck/Sprite2D, "scale", Vector2(5, 5), 0.2)
	tween.parallel().tween_property($Deck/Sprite2D2, "scale", Vector2(5, 5), 0.2)

func _on_select_button_pressed() -> void:
	move_deck_to_sides()
	
func display_deck(deck_name : String):
	var new_name = deck_name.replace("_", " ")
	$Bg/NinePatchRect/Label.text = new_name
	var image_path = "res://Assets/images/Deck/" + new_name + "/" + new_name + ".png"
	$Deck/Sprite2D.texture = load(image_path)
	
	image_path = "res://Assets/images/Deck/" + new_name + "/" + new_name + " spell.png"
	$Deck/Sprite2D2.texture = load(image_path)
	
func switch_deck():
	create_card_labels(CardDatabase.DECKS[deck_index])
	display_deck(CardDatabase.DECKS[deck_index])
		
func _on_button_right_pressed() -> void:
	deck_index += 1
	switch_deck()
	
	$Bg/Button_left.disabled = false
	if deck_index >= CardDatabase.DECKS.size() - 1:
		$Bg/Button_right.disabled = true


func _on_button_left_pressed() -> void:
	deck_index -= 1
	switch_deck()
	
	$Bg/Button_right.disabled = false
	if deck_index <= 0:
		$Bg/Button_left.disabled = true
