extends Node2D

var cardLabel := preload("res://Scenes/CardLabel.tscn")
var show_card_count : int = 0
@onready var deck_1: Node2D = $Deck1
@onready var card: Node2D = $Card


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_card_labels("EXAMPLE_DECK")
	connect_signals()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func connect_signals():
	for label in $Deck1/MarginContainer/MarginContainer/VBoxContainer.get_children():
		label.label_hovered.connect(show_card_info)
		label.label_hovered_off.connect(hide_card_info)
		
	for label in $Deck2/MarginContainer/MarginContainer/VBoxContainer.get_children():
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
	for card in CardDatabase[deck_name]:
		if CardDatabase.CARDS[card["name"]][2] != "Spell":
			var new_label = cardLabel.instantiate()
			$Deck1/MarginContainer/MarginContainer/VBoxContainer.add_child(new_label)
			new_label.name = card["name"]
			new_label.get_node("Label").text = str(card["name"]) + " x" + str(card["amount"])
			
		else:
			var new_label = cardLabel.instantiate()
			$Deck2/MarginContainer/MarginContainer/VBoxContainer.add_child(new_label)
			new_label.name = card["name"]
			new_label.get_node("Label").text = str(card["name"]) + " x" + str(card["amount"])
		
func adjust_card(name):
	card.card_name = name
	card.stat_display.visible = true
	card.description.visible = true
	card.adjust_text_size()
	card.adjust_card_details()
