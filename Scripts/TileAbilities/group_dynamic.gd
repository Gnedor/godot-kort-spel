extends Node
var placed_card

var card_manager = BattleContext.card_manager
const BONUS_MULT = 1.5 # vad tilen ger för mult

func _ready() -> void:
	card_manager.placed_card.connect(add_mult)
	SignalManager.trashed_card.connect(remove_mult)

func tile_ability(card):
	placed_card = card
	for played_card in card_manager.played_cards:
		if played_card != card and played_card.card_name == card.card_name:
			card.round_mult *= BONUS_MULT
			card.turn_mult *= BONUS_MULT
	card.update_card()
			
			
func add_mult(card):
	if !placed_card:
		return
	if card.card_name == placed_card.card_name:
		placed_card.round_mult *= BONUS_MULT
		placed_card.turn_mult *= BONUS_MULT
		placed_card.update_card()
		
func remove_mult(card):
	if placed_card == card:
		return
	if card.card_name == placed_card.card_name:
		placed_card.round_mult /= BONUS_MULT
		placed_card.turn_mult /= BONUS_MULT
		placed_card.update_card()
	
