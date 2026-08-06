extends Camera2D

var randomStregth : float = 5.0
var shake_fade : float = 5.0

var rng = RandomNumberGenerator.new()

var shake_strength : float = 0.0

func _ready() -> void:
	SignalManager.shake_camera.connect(apply_shake)
	
func apply_shake():
	shake_strength = randomStregth
	
func random_offset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shake_fade * delta)
		
		offset = random_offset()
		
func view_collection():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position:y", position.y + 1080, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
