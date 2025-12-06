extends Node

# https://www.youtube.com/watch?v=xe5IJgggbVI -- tutorial

@onready var one_shots: Node = $OneShots
@export var one_shot_scene : PackedScene

@export_group("Extras")
@export var click_audio: AudioStream
@export var text_audio: AudioStream

func play_audio(audio_stream: AudioStream, volume_db: float):
	var sfx = one_shot_scene.instantiate()
	sfx.stream = audio_stream
	sfx.volume_db = volume_db
	
	one_shots.add_child(sfx)
	return sfx
	
func play_click_sound():
	play_audio(click_audio, 0)
	
func animate_text_audio(count : float, time : float):
	var num = 0
	var interval : float = time / count 
	while num < count:
		num += 1
		if num % 2 != 0:
			play_audio(text_audio , -20)
		await Global.timer(interval)
