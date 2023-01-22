extends Node

export(AudioStream) var stream

func play():
	var audio_player = AudioStreamPlayer2D.new()
	owner.get_parent().add_child(audio_player)
	audio_player.stream = stream
	audio_player.global_position = owner.global_position
	audio_player.play()
	audio_player.connect("finished", audio_player, "queue_free")
