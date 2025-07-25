class_name Card
extends Node2D

var description_scene = preload("res://Scenes/description.tscn")

# SPARA BARA DATA HÄR
# INGEN LOGIK !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

@onready var card_sprite: Sprite2D = $Textures/ScaleNode/CardSprite
@onready var stat_display: Sprite2D = $Textures/ScaleNode/StatDisplay
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var namn_label: Label = $Textures/NamnLabel
@onready var area_2d: Area2D = $Area2D
@onready var buy_button: Node2D = $BuyButton
@onready var card_description: MarginContainer = $Textures/VBoxContainer/Description
@onready var trait_description: VBoxContainer = $Textures/VBoxContainer2
@onready var select_border: AnimatedSprite2D = $Textures/ScaleNode/SelectBorder
@onready var trait_1_sprite: TextureRect = $Textures/ScaleNode/VBoxContainer/TextureRect
@onready var trait_2_sprite: TextureRect = $Textures/ScaleNode/VBoxContainer/TextureRect2
@onready var tag_circle: AnimatedSprite2D = $Textures/ScaleNode/CardSprite/TagCircle
@onready var tag_circle_collider: CollisionShape2D = $Textures/ScaleNode/CardSprite/TagCircle/Area2D/CollisionShape2D

var is_placed : bool = false
var is_hovering : bool = false
var in_deck : bool = true
var is_selected : bool = false
var is_discarded : bool = false

var can_poison : bool = true

var attack : int
var turn_attack : int # what attack should be to end of round
var base_attack: int # what attack should be at start of turn

var actions : int
var turn_actions : int # what actions should be to end of round
var base_actions : int # what actions should be at start of turn

var turn_mult : float = 1
var round_mult : float = 1

var card_type : String
var card_name : String
var ability_script
var price : int
var multiplier: float = 1
var tag : String

var trait_1
var trait_2

signal card_initialized

func _ready() -> void:
	var unique_material = card_sprite.material.duplicate()
	card_sprite.material = unique_material
	emit_signal("card_initialized")
	
func place_tag(tag_name : String):
	if tag_name:
		$Textures/ScaleNode/CardSprite/TagSprite.visible = true
		tag_name = tag_name.left(tag_name.length() - 1)
		$Textures/ScaleNode/CardSprite/TagSprite.texture = load("res://Assets/images/Tags/" + tag_name + ".png")
		if !trait_1:
			trait_1 = tag_name
		else:
			trait_2 = tag_name
		update_traits()
	else:
		$Textures/ScaleNode/CardSprite/TagSprite.visible = false
		$Textures/ScaleNode/CardSprite/TagSprite.texture = null
		
func update_traits():
	if trait_1:
		var image_path = "res://Assets/images/Traits/" + trait_1 + "_trait.png"
		$Textures/ScaleNode/VBoxContainer/TextureRect.texture = load(image_path)
		add_trait_description(trait_1, 1)
	else:
		$Textures/ScaleNode/VBoxContainer/TextureRect.texture = null
		
	if trait_2:
		var image_path = "res://Assets/images/Traits/" + trait_2 + "_trait.png"
		$Textures/ScaleNode/VBoxContainer/TextureRect2.texture = load(image_path)
		add_trait_description(trait_2, 2)
	else:
		$Textures/ScaleNode/VBoxContainer/TextureRect2.texture = null
		
func adjust_card_details():
	card_type = CardDatabase.CARDS[card_name][2]
	namn_label.text = card_name
	adjust_text_size()
	var name_label = card_description.name_label
	var description_label = card_description.description_label
	name_label.text = card_name
		
	if CardDatabase.CARDS[card_name][3]:
		description_label.text = "[center]" + str(CardDatabase.CARDS[card_name][3]) + "[/center]"
		Global.color_text(description_label)
	else:
		description_label.text = "[center]Does nothing[/center]"
	adjust_description_text()
	
	if card_type != "Troop":
		var new_card_ability_script_path = CardDatabase.CARDS[card_name][4]
		ability_script = load(new_card_ability_script_path).new()
		add_child(ability_script)
			
	var image_path = "res://Assets/images/kort/" + card_name + "_card.png"
	var texture = load(image_path)
	var sprite = card_sprite
	if sprite:
		sprite.texture = texture
	else:
		print("Sprite node not found")
		
	sprite = card_description.action_sprite
	if card_type != "Troop":
		image_path = "res://Assets/images/ActionTypes/" + card_type + "_type.png"
		texture = load(image_path)

		if sprite:
			sprite.texture = texture
		else:
			print("Sprite node not found")
	else:
		sprite.texture = null
		
	update_traits()
	
func adjust_text_size():
	var font_size = 20
	namn_label.set("theme_override_font_sizes/font_size", font_size)
	while namn_label.get_line_count() > 1:
		font_size -= 1
		namn_label.set("theme_override_font_sizes/font_size", font_size)
		
func adjust_description_text():
	var description_label = card_description.description_label
	description_label.custom_minimum_size = Vector2(260, 0)
	description_label.set_autowrap_mode(2)
	if description_label.get_line_count() <= 1:
		description_label.custom_minimum_size = Vector2(0, 0)
		description_label.set_autowrap_mode(0)
		
func add_trait_description(trait_name, num):
	for child in $Textures/VBoxContainer2.get_children():
		if child.name == trait_1 and num == 1:
			return
		if child.name == trait_2 and num == 2:
			return
			
	var new_description = description_scene.instantiate()
	$Textures/VBoxContainer2.add_child(new_description)
	new_description.name = trait_name
	new_description.get_node("MarginContainer/NameLabel").text = trait_name
	var description_label = new_description.get_node("MarginContainer/MarginContainer/DescriptionLabel")
	for tag in TagDatabase.TAGS:
		if tag["name"] == trait_name:
			description_label.text = "[center][font_size=16]" + tag["description"] + "[/font_size][/center]"
			
	Global.color_text(description_label)
	adjust_description_text()
	
func hover_effect():
	card_description.visible = true
	trait_description.visible = true
	if card_type != "Spell":
		stat_display.visible = true
		
func hover_off_effect():
	card_description.visible = false
	trait_description.visible = false
	stat_display.visible = false
	
func animate_stat_change(type : String):
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	if type == "attack":
		var attack_label = $Textures/ScaleNode/StatDisplay/AttackLabel
		attack_label.position.y -= 8
		tween.tween_property(attack_label, "position:y", 22.667, 0.3)
	elif type == "action":
		var action_label = $Textures/ScaleNode/StatDisplay/ActionsLabel
		action_label.position.y -= 8
		tween.tween_property(action_label, "position:y", 22.667, 0.3)
	else:
		var mult_label = $Textures/ScaleNode/Control
		mult_label.position.y -= 8
		tween.tween_property(mult_label, "position:y", -59, 0.3)
		
func update_card():
	if attack < 0:
		attack = 0
	if turn_attack < 0:
		turn_attack = 0
	if base_attack < 0:
		base_attack = 0
	
	if actions < 0:
		actions = 0
	if turn_actions < 0:
		turn_actions = 0
	if base_actions < 0:
		base_actions = 0
		
	var attack_label = $Textures/ScaleNode/StatDisplay/AttackLabel
	var actions_label = $Textures/ScaleNode/StatDisplay/ActionsLabel
	var mult_label = $Textures/ScaleNode/Control/PanelContainer/MarginContainer/AttackLabel
	
	if is_placed and turn_mult > 1:
		$Textures/ScaleNode/Control.visible = true
	else:
		$Textures/ScaleNode/Control.visible = false
		
	var text = attack_label.text
	Global.round_number(attack_label, attack)
	if text != attack_label.text:
		animate_stat_change("attack")
	text = null
		
	text = actions_label.text
	Global.round_number(actions_label, actions)
	if text != actions_label.text:
		animate_stat_change("action")
	text = null
		
	text = mult_label.text
	Global.round_number(mult_label, turn_mult)
	mult_label.text = "x" + mult_label.text
	if text != mult_label.text:
		animate_stat_change("mult")
	text = null
		

		
		
	
