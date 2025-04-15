extends Node

const TILES = { # "Namn" : [ability description, ability script, type]
	"Speed Tile" : ["Card played on this tile get +1 Actions", "res://Scripts/TileAbilities/speed_tile.gd", "OnPlay"],
	"Attack Tile" : ["Card on this tile deal 2x Damage", "res://Scripts/TileAbilities/attack_tile.gd", "OnAttack"],
	"Group Dynamic" : ["Card played on this tile deals 1.5x Damage for each of the same card currently played", "res://Scripts/TileAbilities/group_dynamic.gd", "OnAttack"],
	"Cool S" : ["Card played on this tile attacks when another card attacks but card Damage is divided by 5", "res://Scripts/TileAbilities/cool_s.gd", "OnPlay"],
	"Cloning tube" : ["Make a random guy in deck a copy of the card played on this tile", "res://Scripts/TileAbilities/cloning_tube.gd", "OnPlay"],
}

const EXAMPLE_DECK = [
	"Speed Tile",
	"Attack Tile",
	"Group Dynamic",
	"Cool S",
	"Cloning tube",
]
