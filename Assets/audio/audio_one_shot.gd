extends AudioStreamPlayer

func _ready() -> void:
	finished.connect(self.queue_free)
	play()
