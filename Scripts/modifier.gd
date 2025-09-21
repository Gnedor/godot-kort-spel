extends Control

@onready var description: MarginContainer = $Description


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_mouse_entered() -> void:
	description.visible = true

func _on_area_2d_mouse_exited() -> void:
	description.visible = false

func adjust_mod_details(mod_name : String, amount : int, mod_trait : String):
	for mod in ModifierDatabase.MODIFIERS:
		if mod["name"] == mod_name:
			var value = mod["start"] + (mod["stack"] * (amount - 1))
			var new_word = "[color=#41ffa3]" + str(value) + "[/color]"
			var new_string = mod["description"].replace("PLACEHOLDER", new_word)
			description.description_label.text = new_string
			
			change_image(name)
			$AmountLabel.text = str(amount) + "x"
			description.name_label.text = mod_name
			apply_trait_effect(mod_trait)
				

	
func change_image(name):
	var img_path = "res://Assets/images/Modifiers/" + name + ".png"
	var texture = load(img_path)
	$TextureRect.texture = texture
	
func apply_trait_effect(effect_name):
	match effect_name:
		"Rainbow":
			var temp = description.name_label.text
			description.name_label.text = "[center][wave amp=10, frec=5][rainbow freq=.2 sat=.9 val=.8]" + temp
		
