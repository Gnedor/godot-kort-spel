extends Control

@onready var description: MarginContainer = $VBoxContainer/Description
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var trait_description: MarginContainer = $VBoxContainer/TraitDescription
@onready var texture_rect: TextureRect = $TextureRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_area_2d_mouse_entered() -> void:
	description.visible = true
	trait_description.visible = true

func _on_area_2d_mouse_exited() -> void:
	description.visible = false
	trait_description.visible = false
	
func adjust_mod_details(mod_name : String, amount : int, mod_trait : String):
	for mod in ModifierDatabase.MODIFIERS:
		if mod["name"] == mod_name:
			var value = mod["start"] + (mod["stack"] * (amount - 1))
			var new_word = "[color=#41ffa3]" + str(value) + "[/color]"
			var new_string = mod["description"].replace("PLACEHOLDER", new_word)
			description.description_label.text = new_string
			
			change_image(name)
			$AmountLabel.text = str(amount) + "x"
			description.name_label.text = "[center]" + mod_name
			
			if mod_trait != "none":
				trait_description.text_box.visible = true
				trait_description.name_label.text = mod_trait
				apply_trait_effect(mod_trait)
				trait_description.description_label.text = "[center]" + ModifierDatabase.TRAITS[mod_trait]
			else:
				trait_description.text_box.visible = false
	
func change_image(name):
	var img_path = "res://Assets/images/Modifiers/" + name + ".png"
	var texture = load(img_path)
	$TextureRect.texture = texture
	
func apply_trait_effect(effect_name):
	apply_shader("res://shaders/ModifierEffects/" + effect_name + ".gdshader")
	
	var temp = trait_description.name_label.text
	match effect_name:
		"Rainbow":
			trait_description.name_label.text = "[center][wave amp=10, frec=5][rainbow freq=.2 sat=.9 val=.8]" + temp
			
		"Dark and Twisted":
			trait_description.name_label.text = "[center][shake][color=#8a0000]" + temp
			
		"Golden":
			trait_description.name_label.text = "[center][color=#FFF15F]" + temp
			
		"#!ERR%&#¤":
			trait_description.name_label.text = "[center][shake][wave freq=.2][tornado radius=1 freq=.2]" + temp
	
func apply_shader(shader_dir : String):
	var shader = load(shader_dir)
	var new_shader = ShaderMaterial.new()
	new_shader.shader = shader
	texture_rect.material = new_shader
