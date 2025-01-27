const TILES = { # "Namn" : [ability description, ability script, type]
	"Speed Tile" : ["Card on this slot get +1 Actions", "res://Scripts/TileAbilities/speed_tile.gd", "OnPlay"],
	"Attack Tile" : ["Card on this slot deal 2x Damage", "res://Scripts/TileAbilities/attack_tile.gd", "OnAttack"]
}

const EXAMPLE_DECK = [
	"Speed Tile",
	"Attack Tile",
]
