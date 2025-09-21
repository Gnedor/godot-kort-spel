extends Control

const MODIFIER = preload("res://Scenes/modifier.tscn")

var new_modifiers = {} #name, amount, trait

func _ready() -> void:
	get_modifiers(3)
	
func get_modifiers(amount):
	for i in range(amount):
		var r = randi() % ModifierDatabase.MODIFIERS.size()
		var new_mod_name = ModifierDatabase.MODIFIERS[r]["name"]
		if new_modifiers.has(new_mod_name):
			new_modifiers[new_mod_name]["amount"] += 1
		else: 
			new_modifiers[new_mod_name] = {
				"amount" = 1,
				"trait" = "Rainbow"
			}
			add_new_mod_object(new_mod_name)
	adjust_modifier_info()
			
func adjust_modifier_info():
	for mod in %ModContainer.get_children():
		mod.adjust_mod_details(mod.name, new_modifiers[mod.name]["amount"], new_modifiers[mod.name]["trait"])
		
func add_new_mod_object(mod_name : String):
	var new_modifier = MODIFIER.instantiate()
	new_modifier.name = mod_name
	%ModContainer.add_child(new_modifier)
		
