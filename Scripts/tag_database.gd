extends Node

const TAGS = [
	{"name": "Poison", "description": "First attack each turn adds Poison based on dealt Damage. Poison deals Damage equal to its value every start of turn"},
	{"name": "Fracture", "description": "Card attack adds 20% Fracture. When fracture reaches over 100%, add 1 level and reset Fracture to 0%, cards deal 2x Damage for each Fracture level"},
	{"name": "Crit", "description": "Card attack adds 10% (max 100%) Crit chance to all attacks. When a card crits, it deals 3x Damage"},
	]
