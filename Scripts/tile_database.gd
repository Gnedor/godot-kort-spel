extends Node

const TILES = { # "Namn" : [ability description, ability script, type]
	"Speed Tile" : ["Card played on this tile get +1 Actions", "res://Scripts/TileAbilities/speed_tile.gd", "OnPlay"],
	"Attack Tile" : ["Card played on this tile deal 2x Damage", "res://Scripts/TileAbilities/attack_tile.gd", "OnPlay"],
	"Group Dynamic" : ["Card played on this tile deals 1.5x Damage for each of the same card currently played", "res://Scripts/TileAbilities/group_dynamic.gd", "OnPlay"],
	"Cool S" : ["Card played on this tile attacks when another card attacks but card Damage is divided by 5", "res://Scripts/TileAbilities/cool_s.gd", "OnPlay"],
	"Cloning tube" : ["When card is played on this tile, make a random guy in deck a copy of the card played on this tile", "res://Scripts/TileAbilities/cloning_tube.gd", "OnPlay"],
	"Pasifism" : ["Cards played on this tile get +2 Actions but can't deal Damage", "res://Scripts/TileAbilities/pasifism.gd", "OnAttack"],
	"Bull's eye" : ["If card on this tile Crit, the card attacks again", "res://Scripts/TileAbilities/bull's_eye.gd", "OnAttack"],
}

const EXAMPLE_DECK = [
	"Speed Tile",
	"Attack Tile",
	"Group Dynamic",
	"Cool S",
	"Cloning tube",
	"Pasifism",
	"Bull's eye"
]
