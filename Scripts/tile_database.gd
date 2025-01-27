const TILES = { # "Namn" : [ability description, ability script, type]
	"Speed Tile" : ["Card played on this tile get +1 Actions", "res://Scripts/TileAbilities/speed_tile.gd", "OnPlay"],
	"Attack Tile" : ["Card on this tile deal 2x Damage", "res://Scripts/TileAbilities/attack_tile.gd", "OnAttack"]
}

const EXAMPLE_DECK = [
	"Speed Tile",
	"Attack Tile",
]
