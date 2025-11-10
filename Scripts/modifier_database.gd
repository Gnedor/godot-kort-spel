extends Node

const MODIFIERS = [
	{"name": "Burning card", "description": "At the start of each turn, discard PLACEHOLDER cards from your hand [color=#717171](+1 per stack)[/color]", "start": 1, "stack": 1},
	{"name": "Thorns", "description": "Cards have a PLACEHOLDER% chance to be discarded after they attack [color=#717171](+5% per stack)[/color]", "start": 10, "stack": 5},
]

const TRAITS = {
	"Rainbow": "All values are [rainbow freq=0.8, sat=0.8, val=0.8]x1.5[/rainbow] [color=#717171](rounded down)[/color]",
	"Dark and Twisted": "Cards deal 10% less damage",
	"Golden": "Add +1 stack of the modifier per 25$ you have",
	"#!ERR%&#¤": "Add or remove 1 stack of the modifier every turn"
}
