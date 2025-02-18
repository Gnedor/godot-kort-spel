const CARDS = { # "Namn" : [Attack, Actions, Card type, ability description, ability script]
	"Guy" : [3, 2, "Troop", null, null],
	"Angry guy" : [5, 1, "Troop", null, null],
	"Magic man" : [2, 2, "OnPlayTroop", "Deals 3 Damage", "res://Scripts/kortAbilities/MagicMan.gd"],
	"Knowledge" : [0, 1, "Spell", "Draw 2 cards from either deck", "res://Scripts/kortAbilities/Knowledge.gd"],
	"Shaman" : [1, 2, "ActiveTroop", "Give a unit +2 Damage for 1 turn", "res://Scripts/kortAbilities/Shaman.gd"],
	"Evil man" : [2, 2, "OnPlayTroop", "Halves Damage on all other played cards and give all removed Damage to self", "res://Scripts/kortAbilities/EvilMan.gd"],
	"Number game" : [0, 1, "Spell", "All played cards get either +2 Damage or -2 Damage this round", "res://Scripts/kortAbilities/NumberGame.gd"],
	"Inevitability" :[3, 2, "OnPlayTroop", "Make two random cards in deck a copy of this card", "res://Scripts/kortAbilities/Inevitability.gd"],
	"Eldritch" : [10, 2, "TurnStartTroop", "Destroy two random played cards (including self)", "res://Scripts/kortAbilities/Eldritch.gd"],
	"Chip" : [0, 1, "Spell", "Give card +1 Actions this turn", "res://Scripts/kortAbilities/Chip.gd"],
	"Glaggle" : [1, 3, "Troop", "Yippie", null],
	"BIG ASS SHOE" : [0, 1, "Spell", "Replaces all played cards with random cards from deck", "res://Scripts/kortAbilities/BigAssShoe.gd"],
	"Banan" : [10, 10, "OnPlayTroop", "On play, give two bordering cards +1 Actions this turn", "res://Scripts/kortAbilities/Banan.gd"],
	"Impossible Shape" : [1, 1, "Troop", "Could this object be built?", null],
	"Gambler" : [1, 1, "Troop", null, null],
	"Groovy guy" : [1, 4, "Troop", null , null]
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
	{"name": "Impossible Shape", "amount": 5},
	{"name": "Gambler", "amount": 5},
	{"name": "Groovy guy", "amount": 5}
]
