extends Node2D

@onready var disabled_sprite: Sprite2D = $DisabledSprite

# SPARA BARA DATA HÄR
# INGEN LOGIK !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

var is_occupied : bool = false
var is_disabled : bool = false
var occupied_card : Node2D
var occupied_tile : Node2D

func toggle_blocked():
	is_disabled = !is_disabled
	disabled_sprite.visible = is_disabled
