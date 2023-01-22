extends Node2D

export var shoot_sound_effect : AudioStream
signal finished


# Called when the node enters the scene tree for the first time.
func _ready():
	if shoot_sound_effect == null:
		shoot_sound_effect = preload("res://sfx/SHOTGUN.wav")
	

func _on_ShootNoise_finished():
	queue_free()
