extends Node

const CARDS = { # "Namn" : [Attack, Actions, Card type, ability description, ability script, starting trait]
	"Guy" : [3, 2, "Troop", "Just a silly guy", null, null],
	"Angry guy" : [5, 1, "Troop", "Just a silly guy, but angry", null, null],
	"Magic man" : [2, 2, "OnPlayTroop", "On play, deal 3 Damage", "res://Scripts/kortAbilities/MagicMan.gd", null],
	"Knowledge" : [0, 1, "Spell", "Draw 2 cards from either deck", "res://Scripts/kortAbilities/Knowledge.gd", null],
	"Shaman" : [1, 2, "ActiveTroop", "Give a unit +2 Damage for 1 turn", "res://Scripts/kortAbilities/Shaman.gd", null],
	"Evil man" : [2, 2, "OnPlayTroop", "On play, halves Damage on all other played cards and give all removed Damage to self", "res://Scripts/kortAbilities/EvilMan.gd", null],
	"Number game" : [0, 1, "Spell", "All played cards get either +2 Damage or -2 Damage this round", "res://Scripts/kortAbilities/NumberGame.gd", null],
	"Inevitability" :[3, 2, "OnPlayTroop", "On play, make two random guys in deck a copy of this card", "res://Scripts/kortAbilities/Inevitability.gd", null],
	"Eldritch" : [10, 2, "TurnStartTroop", "Each turn, discard one random played card (including self)", "res://Scripts/kortAbilities/Eldritch.gd", null],
	"Chip" : [0, 1, "Spell", "Give card +2 Actions this turn", "res://Scripts/kortAbilities/Chip.gd", null],
	"Glaggle" : [1, 3, "Troop", "Yippie", null, null],
	"BIG ASS SHOE" : [0, 1, "Spell", "Discard all played cards and place random guys from deck on all card slots", "res://Scripts/kortAbilities/BigAssShoe.gd", null],
	"Banan" : [2, 2, "OnPlayTroop", "On play, give two bordering cards +1 Actions this turn", "res://Scripts/kortAbilities/Banan.gd", null],
	"Paradox" : [1, 1, "Troop", "Could this object be built?", null, null],
	"Gambler" : [1, 2, "Troop", "Guy living in the moment", null, "Crit"],
	"Groovy guy" : [1, 2, "Troop", "Guy feeling the groove" , null, "Fracture"],
	"Overkiller" : [5, 1, "OnAttackTroop", "If this card deals more than the total Damage done this round, gain +1 Actions this round", "res://Scripts/kortAbilities/Overkiller.gd", null],
	"Goop" : [2, 2, "Troop", "Gooby wooby", null, "Poison"],
	"Juice Up" : [0, 1, "Spell", "Give a card x2 Damage for 1 turn, the card permanently looses 3 Damage after the effect", "res://Scripts/kortAbilities/JuiceUp.gd", null],
	"Dumpster fire" : [3, 2, "OnAttackTroop", "This card deals 1.5x Damage for every two cards discarded this round", "res://Scripts/kortAbilities/DumpsterFire.gd", null],
	
	#behöver sprites
	#"Trash Man" : [3, 2, "OnTrashCard", "When trashed, permanently gain 3 Damage", null, null],

}

const EXAMPLE_DECK = [
	{"name": "Guy", "amount": 10},
	{"name": "Angry guy", "amount": 7},
	{"name": "Magic man", "amount": 5},
	{"name": "Knowledge", "amount": 5},
	{"name": "Shaman", "amount": 5},
	{"name": "Evil man", "amount": 5},
	{"name": "Number game", "amount": 5},
	{"name": "Inevitability", "amount": 5},
	{"name": "Eldritch", "amount": 5},
	{"name": "Chip", "amount" : 5},
	{"name": "Glaggle", "amount": 3},
	{"name": "BIG ASS SHOE", "amount": 20},
	{"name": "Banan", "amount": 5},
	{"name": "Paradox", "amount": 5},
	{"name": "Gambler", "amount": 5},
	{"name": "Groovy guy", "amount": 5},
	{"name": "Overkiller", "amount": 5},
	{"name": "Goop", "amount": 5},
	{"name": "Juice Up", "amount": 3},
	{"name": "Dumpster fire", "amount": 3},
]
