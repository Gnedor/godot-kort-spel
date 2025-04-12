extends Node2D

# SPARA BARA DATA HÄR
# INGEN LOGIK !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

@onready var card_sprite: Sprite2D = $Textures/ScaleNode/CardSprite
@onready var stat_display: Sprite2D = $Textures/ScaleNode/StatDisplay
@onready var attack_label: Label = $Textures/ScaleNode/StatDisplay/AttackLabel
@onready var actions_label: Label = $Textures/ScaleNode/StatDisplay/ActionsLabel
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var namn_label: Label = $Textures/NamnLabel
@onready var area_2d: Area2D = $Area2D
@onready var buy_button: Node2D = $BuyButton
@onready var description_label: RichTextLabel = $Textures/Description/MarginContainer/MarginContainer/DescriptionLabel
@onready var name_label: Label = $Textures/Description/MarginContainer/NameLabel
@onready var description: MarginContainer = $Textures/Description
@onready var action_sprite: TextureRect = $Textures/Description/NinePatchRect/TextureRect
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
var card_type : String
var card_name : String
var ability_script
var price : int
var multiplier: float = 1
var tag : String

var trait_1
var trait_2

func _ready() -> void:
	var unique_material = card_sprite.material.duplicate()
	card_sprite.material = unique_material
	
func place_tag(tag_name : String):
	$Textures/ScaleNode/CardSprite/TagSprite.visible = true
	$Textures/ScaleNode/CardSprite/TagSprite.texture = load("res://Assets/images/Tags/" + tag_name + ".png")
	if !trait_1:
		trait_1 = tag_name
	else:
		trait_2 = tag_name
	update_traits()
	
func update_traits():
	if trait_1:
		var image_path = "res://Assets/images/Traits/" + trait_1 + "_trait.png"
		$Textures/ScaleNode/VBoxContainer/TextureRect.texture = load(image_path)
		
	if trait_2:
		var image_path = "res://Assets/images/Traits/" + trait_2 + "_trait.png"
		$Textures/ScaleNode/VBoxContainer/TextureRect2.texture = load(image_path)
