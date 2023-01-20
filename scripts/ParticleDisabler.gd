extends CPUParticles2D

func _enter_tree():
	if Global.user_prefs["particles"] == false:
		hide()
