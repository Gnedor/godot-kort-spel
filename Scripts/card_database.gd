const CARDS = { # "Namn" : [Attack, Actions, Card type, ability description, ability script]
	"Guy" : [3, 2, "Troop", null, null],
	"Angry guy" : [5, 1, "Troop", null, null],
	"Magic man" : [2, 2, "OnPlayTroop", "Deals 3 damage on play", "res://Scripts/kortAbilities/MagicMan.gd"],
	"Knowledge" : [0, 1, "Spell", "Draw 2 cards from either deck", "res://Scripts/kortAbilities/Knowledge.gd"],
	"Shaman" : [1, 2, "ActiveTroop", "Give a unit +2 damage for 1 turn", "res://Scripts/kortAbilities/Shaman.gd"],
	"Evil man" : [2, 2, "OnPlayTroop", "Halves damage on all alies and give all removed damage to itself", "res://Scripts/kortAbilities/EvilMan.gd"],
	"Number game" : [0, 1, "Spell", "All cards get either +2 damager or -2 damage", "res://Scripts/kortAbilities/NumberGame.gd"],
	"Inevitability" :[3, 2, "OnPlayTroop", "When played, make two random cards in deck a copy of this card", "res://Scripts/kortAbilities/Inevitability.gd"],
	"Eldritch" : [10, 2, "Troop", "On start of turn, chance to destroy ANY two played cards", "res://Scripts/kortAbilities/Eldritch.gd"],
	"Chip" : [0, 1, "Spell", "Add one action", "res://Scripts/kortAbilities/Chip.gd"],
	"Glaggle" : [1, 3, "Troop", "Yippie", "res://Scripts/kortAbilities/Glaggle.gd"],
	"BIG ASS SHOE" : [0, 1, "Spell", "Replaces all played cards with random cards from deck", "res://Scripts/kortAbilities/BigAssShoe.gd"],
	"Banan" : [10, 10, "Troop", null, null]
}

const EXAMPLE_DECK = [
	{"name": "Guy", "amount": 30},
	{"name": "Angry guy", "amount": 10},
	{"name": "Magic man", "amount": 5},
	{"name": "Knowledge", "amount": 7},
	{"name": "Shaman", "amount": 5},
	{"name": "Evil man", "amount": 5},
	{"name": "Number game", "amount": 5},
	{"name": "Inevitability", "amount": 5},
	{"name": "Eldritch", "amount": 5},
	{"name": "Chip", "amount" : 5},
	{"name": "Glaggle", "amount": 3},
	{"name": "BIG ASS SHOE", "amount": 5},
	{"name": "Banan", "amount": 5},
]
