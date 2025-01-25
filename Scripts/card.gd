extends Node2D

# SPARA BARA DATA HÄR
# INGEN LOGIK !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

@onready var card_sprite: Sprite2D = $Textures/ScaleNode/CardSprite
@onready var stat_display: Sprite2D = $Textures/ScaleNode/StatDisplay
@onready var attack_label: Label = $Textures/ScaleNode/StatDisplay/AttackLabel
@onready var actions_label: Label = $Textures/ScaleNode/StatDisplay/ActionsLabel
@onready var ability_description_text: Label = $Textures/AbilityDescriptionText
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var namn_label: Label = $Textures/NamnLabel
@onready var area_2d: Area2D = $Area2D
@onready var button: Button = $MarginContainer/Button
@onready var price_label: Label = $MarginContainer/MarginContainer/Price

signal buy_card

var is_placed : bool = false
var is_hovering : bool = false
var in_deck : bool = true
var is_selected : bool = false
var is_discarded : bool = false

var attack : int
var turn_attack : int # what attack should be to end of round
var base_attack: int # what attack should be at start of round
var actions : int
var turn_actions : int # what actions should be to end of round
var base_actions : int # what actions should be at start of turn
var card_type : String
var card_name : String
var ability_script
var price : int

func _ready() -> void:
	#get_parent().connect_card_signals(self)
	var unique_material = card_sprite.material.duplicate()
	card_sprite.material = unique_material

func _on_button_pressed() -> void:
	buy_card.emit(self)

func _on_button_button_down() -> void:
	price_label.position.y += 2

func _on_button_button_up() -> void:
	price_label.position.y -= 2
