extends Control

@onready var tag_area: NinePatchRect = $EditArea/Options/TagArea/NinePatchRect2
@onready var scene_manager: Control = $CardEditorSceneManager
const TAG_SCENE = preload("res://Scenes/tag.tscn")

var stored_card
var clicked_tag
var stored_tag_pos
var stored_tags = []

const TAG_Y = 6
const TAG_X = 4
const TAG_SPACING = 96

const TAG_MASK = 512
const TAG_SLOT_MASK = 1024

func _ready() -> void:
	$CardEditorSceneManager.on_scene_enter.connect(on_enter)
	
func _process(_delta: float) -> void:
	if clicked_tag:
		var mouse_pos = get_global_mouse_position()
		clicked_tag.global_position = Vector2(mouse_pos.x - clicked_tag.size.x / 2, mouse_pos.y - clicked_tag.size.y / 2)

func _input(event):
	if Global.scene_name != "editor" or event is not InputEventMouseButton or event.button_index != MOUSE_BUTTON_LEFT:
		return
	if $CardEditorSceneManager.in_collection:
		var card = $CardCollection.check_for_card()
		if !card or card == stored_card:
			return
		
		$CardEditorSceneManager.in_collection = false
		if stored_card:
			$CardCollection.cards_in_collection.append(stored_card)
		stored_card = card

		scene_manager.collection_down()
		await Global.timer(0.5)

		adjust_description(card)
		card.global_position = %CardPoint.global_position
		card.visible = true
		card.scale = Vector2(1.2, 1.2)
		var tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
		tween.tween_property(card, "scale", Vector2(1.0, 1.0), 0.1)
	else:
		var hit = raycast_check(TAG_MASK)
		if hit:
			on_tag_click(hit)
		else:
			on_release()
			
func on_enter():
	get_tags()

func on_tag_click(tag : Control):
	var tag_name = String(tag.name)
	var i := int(tag_name[-1])
	stored_tag_pos = Vector2(TAG_X + (TAG_SPACING * i), TAG_Y)
	clicked_tag = tag
	tag.z_index = 2
	for child in tag_area.get_children():
		child.disable_collision(true)
	
	if stored_card:
		stored_card.area_2d.get_child(0).disabled = true
		if stored_card.card_type != "Spell" and stored_card.tag == "":
			stored_card.disable_tag_circle(false)
				
func on_release():
	if clicked_tag:
		release_tag(clicked_tag)
	
func apply_tag(tag):
	stored_card.place_tag(tag.name)
	adjust_description(stored_card)
	tag.queue_free()

func release_tag(tag):
	if raycast_check(TAG_SLOT_MASK):
		apply_tag(tag)
	
	if stored_card:
		stored_card.area_2d.get_child(0).disabled = false
		stored_card.disable_tag_circle(true)
		
	for child in tag_area.get_children():
		child.disable_collision(false)
	tag.z_index = 0
	clicked_tag = null
	
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(tag, "position", stored_tag_pos, 0.1)
	#tag.position = stored_tag_pos

func adjust_description(card):
	var description_label = %DescriptionText
	var name_label = $EditArea/Control/Name/MarginContainer/NameLabel
	name_label.text = card.card_name
	
	description_label.text = "[center]" + str(CardDatabase.CARDS[card.card_name][3])
	Global.color_text(description_label)
	
	if card.card_type != "Spell":
		$EditArea/Control/StatDisplay/AttackLabel.text = str(card.attack)
		$EditArea/Control/StatDisplay/ActionsLabel.text = str(card.actions)
	else:
		$EditArea/Control/StatDisplay/AttackLabel.text = ""
		$EditArea/Control/StatDisplay/ActionsLabel.text = ""
	
	var image_path = "res://Assets/images/ActionTypes/" + card.card_type + "_type.png"
	%CardType.texture = load(image_path)
	
	var tween = get_tree().create_tween()
	
	var anim_time = get_anim_time(description_label)
	
	name_label.visible_ratio = 0.0
	description_label.visible_ratio = 0.0
	
	if card.trait_1:
		%"Trait 1".visible = true
		adjust_trait_description(%Trait1Name, %Trait1Description, card.trait_1)
	else: 
		%"Trait 1".visible = false
		
	if card.trait_2:
		%"Trait 2".visible = true
		adjust_trait_description(%Trait2Name, %Trait2Description, card.trait_2)
	else:
		%"Trait 2".visible = false
	
	tween.tween_property(name_label, "visible_ratio", 1.0 , 0.2)
	AudioManager.animate_text_audio(str(name_label.get_text()).length(), 0.2)
	await tween.finished
	
	tween = get_tree().create_tween()
	tween.tween_property(description_label, "visible_ratio", 1.0, anim_time)
	AudioManager.animate_text_audio(str(description_label.get_text()).length(), anim_time)
	
func get_anim_time(label):
	var anim_time = label.get_line_count() * 0.5
	return anim_time
	
func adjust_trait_description(name_label, description_label, trait_name):
	name_label.text = trait_name
	for tag in TagDatabase.TAGS:
		if tag["name"] == trait_name:
			description_label.text = tag["description"]
	Global.color_text(description_label)
	Global.color_text(name_label)
	name_label.text = "[center]" + name_label.text
	
func trash_card():
	if stored_card:
		await play_trash_animation()
		stored_card.free()
		SignalManager.signal_emitter("removed_card")
		stored_card = null
	
func play_trash_animation():
	$TrashCard.get_node("AnimationPlayer").play("trash_card_anim")
	await Global.timer(0.1667)
	stored_card.visible = false
	
func raycast_check(mask : int):
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = mask
	var result = space_state.intersect_point(parameters)
	# om den hittar kort returnerar den parent Noden
	if result.size() > 0:
		return result[0].collider.get_parent()
	else:
		return null
		
func get_tags():
	for tag in $EditArea/Options/TagArea/NinePatchRect2.get_children():
		tag.queue_free()
	
	var i := 0
	for tag_name in Global.stored_tags:
		var new_tag = TAG_SCENE.instantiate()
		new_tag.name = tag_name + str(i)
		$EditArea/Options/TagArea/NinePatchRect2.add_child(new_tag)
		new_tag.on_hover.connect(on_tag_hover)
		new_tag.on_hover_off.connect(on_tag_hover_off)
		new_tag.get_node("TextureRect").texture = load("res://Assets/images/Tags/" + tag_name + ".png")
		new_tag.position = Vector2(TAG_X + (TAG_SPACING * i), TAG_Y)
		
		i += 1
		
func on_tag_hover(tag : Control):
	scene_manager.drop_tag_description()
	set_tag_desc_text(tag)
	
func on_tag_hover_off():
	scene_manager.remove_tag_descripton()
		
func set_tag_desc_text(tag : Control):
	var tag_name = tag.name
	tag_name = tag_name.left(tag_name.length() - 1)
	var desc_label = $EditArea/Options/TagArea/TagDescription/MarginContainer/MarginContainer/DescriptionText
	var tag_desc : String
	for t in TagDatabase.TAGS:
		if t["name"] == tag_name:
			tag_desc = t["description"]
			
	desc_label.text = "\n\n\n[center][font_size=20]" + tag_name + "[/font_size][/center]\n\n" + tag_desc
	Global.color_text(desc_label)
	
	var anim_time = get_anim_time(desc_label)
	desc_label.visible_ratio = 0
	var tween = get_tree().create_tween()
	tween.tween_property(desc_label, "visible_ratio", 1.0, 0.2)
