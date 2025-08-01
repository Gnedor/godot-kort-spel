extends Node2D


func play_anim():
	$CPUParticles2D.emitting = true
	$CPUParticles2D2.emitting = true
	await Global.timer(3)
	queue_free()
