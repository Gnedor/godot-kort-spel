extends Node

const TAGS = [
	{"name": "Poison", "description": "First attack each turn adds Poison based on dealt Damage. Poison deals Damage equal to its value every start of turn"},
	{"name": "Fracture", "description": "Attacks adds 20% Fracture. When over 100%, add 1 level and reset Fracture to 0%, cards deal 2x Damage per level"},
	{"name": "Crit", "description": "Attacks add 10% Crit chance to all attacks [color=#717171](max 100%)[/color]. A Crit deal 3x Damage"},
	{"name": "Echo", "description": "Attacks apply 1 Echo, applying over 3 stacks will reset Echo and draw on card from both decks"},
	]
