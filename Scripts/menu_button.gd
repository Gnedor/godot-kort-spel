extends Button

var tween

func anim_hover():
	tween = get_tree().create_tween()
	tween.tween_property(self, "custom_minimum_size", Vector2(600, 100), 0.1)
	
func anim_hover_off():
	tween = get_tree().create_tween()
	tween.tween_property(self, "custom_minimum_size", Vector2(574, 90), 0.1)


func _on_mouse_entered() -> void:
	anim_hover()

func _on_mouse_exited() -> void:
	anim_hover_off()



func _on_button_down() -> void:
	tween = get_tree().create_tween()
	tween.tween_property(self, "custom_minimum_size", Vector2(580, 95), 0.05)


func _on_button_up() -> void:
	tween = get_tree().create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "custom_minimum_size", Vector2(610, 110), 0.2)
	tween.tween_property(self, "custom_minimum_size", Vector2(574, 90), 0.1)
