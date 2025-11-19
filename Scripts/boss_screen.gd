extends Control

const MODIFIER = preload("res://Scenes/modifier.tscn")

@onready var reroll_button: Button = $ModifierScreen/HBoxContainer/RerollButton
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var saved_amount : int
var have_rerolled : bool
var rerolls : int

var new_modifiers = {} #name, amount, trait

@export var is_ready : bool = false

func _ready() -> void:
	pass
	
func on_enter():
	rerolls = Global.base_modifier_rerolls
	
func get_modifiers(amount):
	if !have_rerolled:
		saved_amount = amount
	for i in range(saved_amount):
		var r = randi() % ModifierDatabase.MODIFIERS.size()
		var new_mod_name = ModifierDatabase.MODIFIERS[r]["name"]
		var mod_trait = "none"
		
		if new_modifiers.has(new_mod_name):
			new_modifiers[new_mod_name]["amount"] += 1
			for mod in %ModContainer.get_children():
				if mod.name == new_mod_name:
					mod.animation_player.play("pulse text")
		else: 
			if i <= ((Global.round / 3) - 1):
				mod_trait = ModifierDatabase.TRAITS.keys().pick_random()
			
			new_modifiers[new_mod_name] = {
				"amount": 1,
				"trait": mod_trait
			}
			add_new_mod_object(new_mod_name)
		adjust_modifier_info(new_mod_name)
		await Global.timer(0.1)
	reroll_button.disabled = false
		
func adjust_modifier_info(mod_name : String):
	for mod in %ModContainer.get_children():
		if mod.name == mod_name:
			mod.adjust_mod_details(mod.name, new_modifiers[mod.name]["amount"], new_modifiers[mod.name]["trait"])
		
func add_new_mod_object(mod_name : String):
	var new_modifier = MODIFIER.instantiate()
	new_modifier.name = mod_name
	%ModContainer.add_child(new_modifier)
	new_modifier.animation_player.play("pulse")
		
func _input(event):
	pass
	if event is InputEventMouseButton or event is InputEventKey:
		if event.pressed and is_ready:
			$AnimationPlayer.play("Transition")
			
func reroll():
	reroll_button.disabled = true
	have_rerolled = true
	for n in %ModContainer.get_children():
		%ModContainer.remove_child(n)
		n.queue_free()
	new_modifiers.clear()
	get_modifiers(1)

func _on_reroll_button_pressed() -> void:
	reroll()
	if rerolls <= 0:
		reroll_button.disabled = true


func _on_continue_button_pressed() -> void:
	animation_player.play("On Continue")
