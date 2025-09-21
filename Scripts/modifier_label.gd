extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = "[rainbow freq=.2 sat=.9 val=.8][center][wave amp=40, frec=20]Boss Modifiers"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
