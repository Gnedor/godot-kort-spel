extends Node2D

@onready var card_manager: Node2D = $"../CardManager"
@onready var sten: Node2D = $"../sten"
@onready var deck: Node2D = $"../TroopDeck"
@onready var attack_timer: Timer = $AttackTimer
@onready var total_damage_label: Label = $TotalDamage
@onready var turn_counter: Label = $TurnCounter
@onready var card_slots: Node2D = $"../CardSlots"
@onready var end_turn: Button = $EndTurn
@onready var darken_background: ColorRect = $DarkenBackground
@onready var hand_info: Label = $HandInfo
@onready var input_manager: Node2D = $"../InputManager"
@onready var end_turn_label: Label = $EndTurn/EndTurnLabel
@onready var round_label: Label = $"../Round Box/ColorRect/ColorRect/RoundLabel"
@onready var money_label: Label = $"../Round Box/Money Box/ColorRect/ColorRect/MoneyLabel"
@onready var tiles_folder: Node2D = $"../TilesFolder"
@onready var scene_manager: Node2D = $"../SceneManager"
@onready var camera_2d: Camera2D
@onready var debuff_icons: VBoxContainer = $"../DebuffIcons"
@onready var debuff_text: VBoxContainer = $"../DebuffText"

var turns : int
var card_index : int
var turn : int = 1
var invert_tween
var active_select : bool = false
var deck_select :  bool = false
var selected_card : Node2D
var ability_card : Node2D
var amount_to_draw : int

var debuffs = {
	"poison": 0,
	"fracture": 0,
	}
	#{"Debuff": "namn", "amount", float}

var end_turn_label_position_y

signal end_round

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camera_2d = get_parent().get_parent().get_node("Camera2D")
	scene_manager.on_scene_enter.connect(on_enter)
	input_manager.click_on_sten.connect(attack)
	input_manager.trigger_ability.connect(enter_active_card_activate)
	input_manager.untrigger_ability.connect(exit_active_card_activate)
	input_manager.select_target_card.connect(activate_card_abilities)
	input_manager.select_deck.connect(on_deck_chosen)
	
func on_enter():
	Global.total_damage = 0
	
	for debuff in debuffs:
		debuff = 0
	
	turn = 1
	end_turn.disabled = false
	turn_counter.text = "Turn: " + str(turn) + "/3"
	round_label.text = "Round: " + str(Global.round)
	money_label.text = str(Global.total_money) + "$"
	total_damage_label.text = str(Global.total_damage) + "/" + str(Global.quota)
	hand_info.text = ("")
	
	toggle_invert(sten.get_node("Sprite2D"), false)
	end_turn_label_position_y = end_turn_label.position.y
	
func new_turn():
	Global.total_damage += debuffs["poison"]
	debuffs["fracture"] = 0
	update_labels()
	
	if turn <= 2:
		turn += 1	
		turn_counter.text = "Turn: " + str(turn) + "/3"
		card_manager.draw_cards(3, 1)
		for card in card_manager.played_cards:
			card.attack = card.turn_attack
			card.actions = card.turn_actions
			card_manager.update_card(card)

			#if card.card_type == "TurnStartTroop":
				
		end_turn.disabled = true
		await Global.timer(0.1)
		end_turn.disabled = false

		await get_tree().create_timer(0.5).timeout
	else:
		end_turn.disabled = true
		if Global.total_damage > Global.highest_damage:
			Global.highest_damage = Global.total_damage
		if Global.total_money > Global.highest_money:
			Global.highest_money = Global.total_money
		on_end_round()

func attack(played_cards):
	if tiles_folder.menu_up:
		for card in played_cards:
			if card.is_selected:
				card.actions -= 1
				check_for_tile(card)
				card_manager.update_card(card)
				card.stat_display.visible = false
				animate_attack(card, sten.attack_point.global_position, get_rotation_angle(card), 0.15)
				card.stat_display.visible = true
				card_manager.deselect_effect(card)
				card.is_selected = false
				
				await get_tree().create_timer(0.15).timeout
				animate_invert_blink(sten)
				camera_2d.apply_shake()
				
				var damage = card.attack * card.multiplier

				card.multiplier = 1
				
				if card.trait_1:
					if debuffs[card.trait_1] == 0:
						create_debuff_icon(card.trait_1)
						
					match card.trait_1:
						"poison":
							debuffs["poison"] += damage
							
						"fracture":
							var fracture = debuffs["fracture"]
							if debuffs["fracture"] != 100:
								damage *= (debuffs["fracture"] + 100) / 100 
								debuffs["fracture"] += 20
							else: 
								damage *= 3
								debuffs["fracture"] = 0
							
				Global.total_damage += int(round(damage))
	update_labels()
				
func check_for_tile(card):
	for slot in card_manager.card_slots.get_children():
		if slot.global_position.x == card.global_position.x:
			if slot.occupied_tile:
				if slot.occupied_tile.tile_type == "OnAttack":
					slot.occupied_tile.ability_script.tile_ability(card)
			
			
func _on_attack_timer_timeout() -> void:
	pass # Replace with function body.
	
	
func animate_attack(card : Node2D, position : Vector2, rotation : float, speed : float):
	var original_position = card.position
	var original_rotation = card.rotation
	
	var tween_position = get_tree().create_tween()
	var tween_rotation = get_tree().create_tween()
	
	tween_position.tween_property(card, "position", position, speed).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween_rotation.tween_property(card, "rotation", rotation, speed).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	
	tween_position.tween_property(card, "position", original_position, speed).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween_rotation.tween_property(card, "rotation", original_rotation, speed).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	update_labels()
	
func get_rotation_angle(card : Node2D):
	var rotation = sten.get_node("AttackPoint").global_position.angle_to_point(card.position)
	return rotation - PI/2


func _on_end_turn_pressed() -> void:
	new_turn()
	
	
func _on_end_turn_button_down() -> void:
	end_turn_label.position.y = end_turn_label_position_y + 3
	
	
func _on_end_turn_button_up() -> void:
	end_turn_label.position.y = end_turn_label_position_y
	
	
func on_end_round():
	end_round.emit()
	
	
func toggle_invert(node, enable : bool):
	node.material.set("shader_parameter/invert_strength", 1.0 if enable else 0.0)
	
	
func animate_invert_blink(node):
	var sprite_node = node.get_node("Sprite2D")
	if invert_tween:
		invert_tween.kill()
		
	toggle_invert(sprite_node, true)
	
	invert_tween = create_tween()
	invert_tween.tween_property(sprite_node.material, "shader_parameter/invert_strength", 0.0, 0.5)
	
	
func ability_effect(card : Node2D):
	var tween_in = get_tree().create_tween()
	tween_in.parallel().tween_property(card, "scale", Vector2(1.1, 1.1), 0.1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween_in.parallel().tween_property(card.card_sprite.material, "shader_parameter/hit_opacity", 1.0, 0.1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween_in.parallel().tween_property(card.namn_label, "theme_override_colors/font_color", Color(1, 1, 1, 1), 0.2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	await tween_in.finished
	
	var tween_out = get_tree().create_tween()
	tween_out.parallel().tween_property(card, "scale", Vector2(1, 1), 0.2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween_out.parallel().tween_property(card.card_sprite.material, "shader_parameter/hit_opacity", 0.0, 0.2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	tween_out.parallel().tween_property(card.namn_label, "theme_override_colors/font_color", Color(0, 0, 0, 1), 0.2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	await tween_out.finished
	

func throw_projectile_from_card(animation_name : String, card : Node2D, time : float, damage : float):
	card.animated_sprite.play(animation_name)
	card.animated_sprite.frame = 0
	card.animated_sprite.pause()
	
	var tween = get_tree().create_tween()
	
	var target_position = card.to_local(sten.attack_point.global_position)
	tween.tween_property(card.animated_sprite, "position", target_position, 0.2)
	
	await tween.finished
	
	card.animated_sprite.play()
	animate_invert_blink(sten)
	camera_2d.apply_shake()
			
	Global.total_damage += damage
	total_damage_label.text = str(Global.total_damage)
	
	
func enter_active_card_activate():
	if card_manager.played_cards:
		active_select = true
		for card in card_manager.played_cards:
			card.z_index = card_manager.cards_in_hand.size() + 5
			
		for card in card_manager.cards_in_hand:
			card.get_node("Area2D/CollisionShape2D").disabled = true
			
		end_turn.disabled = true
		darken_background.z_index = card_manager.cards_in_hand.size() + 4
		hand_info.z_index = card_manager.cards_in_hand.size() + 5
		hand_info.visible_ratio = 0.0
		hand_info.text = ("Select Target Card")
	
		await darken_screen()
		add_text(hand_info)
	
	
func activate_card_abilities():
	for card in card_manager.played_cards:
		
		if card.card_type == "ActiveTroop" and card.is_selected:
			card.is_selected = false
			await card.ability_script.trigger_ability(card, self, deck, card_manager, selected_card)
		else:
			card_manager.deselect_effect(card)
			
	exit_active_card_activate()
		
		
func exit_active_card_activate():
	for card in card_manager.cards_in_hand:
		card.get_node("Area2D/CollisionShape2D").disabled = false
	
	await remove_text(hand_info)
	await brighten_screen()
	
	end_turn.disabled = false
	active_select = false
	
	for card in card_manager.played_cards:
		card.z_index = 2
		card_manager.deselect_effect(card)
		card.is_selected = false
		
	hand_info.z_index = card_manager.cards_in_hand.size() + 5
	hand_info.text = ("")
	
	
func enter_chose_deck(played_card, draw_amount):
	amount_to_draw = draw_amount
	ability_card = played_card
	deck_select = true
	hand_info.visible_ratio = 0.0
	hand_info.text = ("Chose Deck")
	
	for card in card_manager.cards_in_hand:
		card.get_node("Area2D/CollisionShape2D").disabled = true
	played_card.get_node("Area2D/CollisionShape2D").disabled = true
	end_turn.disabled = true
	tiles_folder.button.disabled = true
	played_card.z_index = card_manager.cards_in_hand.size() + 10
	deck.z_index = card_manager.cards_in_hand.size() + 10
	deck.spell_deck.z_index = card_manager.cards_in_hand.size() + 10
	hand_info.z_index = card_manager.cards_in_hand.size() + 10
	darken_background.z_index = card_manager.cards_in_hand.size() + 3
		
	await darken_screen()
	add_text(hand_info)
	
	
func on_deck_chosen(chosen_deck):
	var cards = []
	cards.append(ability_card)
	var clicked_deck = chosen_deck[0].collider.get_parent()
	if clicked_deck == deck:
		await card_manager.draw_cards(amount_to_draw, 0)
	else:
		await card_manager.draw_cards(0, amount_to_draw)
	await Global.timer(0.2)
	exit_chose_deck()
	
	
func exit_chose_deck():
	var cards = []
	cards.append(ability_card)
	deck_select = false
	await remove_text(hand_info)
	await brighten_screen()
	
	end_turn.disabled = false
	tiles_folder.button.disabled = false
	
	for card in card_manager.cards_in_hand:
		card.get_node("Area2D/CollisionShape2D").disabled = false
	
	deck.z_index = 1
	deck.spell_deck.z_index = 1
	
	ability_card.z_index = 1
	card_manager.discard_selected_cards(cards, "Hand")
	
	
func darken_screen():
	var tween = get_tree().create_tween()
	tween.tween_property(darken_background, "color", Color(0, 0, 0, 0.7), 0.1)
	await tween.finished
		
		
func brighten_screen():
	var tween = get_tree().create_tween()
	tween.tween_property(darken_background, "color", Color(0, 0, 0, 0), 0.1)
	await tween.finished
	
	
func add_text(label):
	var tween = get_tree().create_tween()
	tween.tween_property(label, "visible_ratio", 1.0, 0.2)
	await tween.finished
	
	
func remove_text(label):
	var tween = get_tree().create_tween()
	tween.tween_property(label, "visible_ratio", 0, 0.2)
	await tween.finished
	
func update_labels():
	total_damage_label.text = str(Global.total_damage) + "/" + str(Global.quota)
	var child_count = debuff_icons.get_child_count()
	
	var i = 0
	for label in debuff_text.get_children().duplicate():
		label.text = str(debuffs[label.name])
		if debuffs[label.name] == 0:
			debuff_icons.get_child(i).queue_free()
			label.queue_free()
		i += 1
func create_debuff_icon(debuff_name : String):
	var texture_rect = TextureRect.new()
	texture_rect.texture = load("res://Assets/images/Tags/" + debuff_name + ".png")
	debuff_icons.add_child(texture_rect)
	texture_rect.name == debuff_name
			
	var label = Label.new()
	label.text = str(debuffs[debuff_name])
	if debuff_name == "fracture":
		label.text += "%"
	debuff_text.add_child(label)
			
	var label_settings = LabelSettings.new()
	label_settings.font = load("res://Assets/fonts/PixelOperator8.ttf")
	label_settings.font_size = 36
	label_settings.font_color = Color(0.455, 0.765, 0.243)
	label.label_settings = label_settings
	label.name = debuff_name
	
