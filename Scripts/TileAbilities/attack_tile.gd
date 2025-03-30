extends Node

func tile_ability(card):
	card.multiplier *= 2
	
	#await Global.timer(0.05)
	#card.attack *= 2
	#await Global.timer(0.11)
	#if card.attack > 0:
		#card.attack /= 2
