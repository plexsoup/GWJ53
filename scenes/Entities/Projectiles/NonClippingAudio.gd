extends AudioStreamPlayer2D


func play_until_done():
	connect("finished", self, "queue_free")
#	yield(Engine.get_main_loop(), "idle_frame")
	get_parent().remove_child(self)
	Global.current_scene.add_child(self)
