extends Control


signal finished


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _unhandled_key_input(event):
	if event.scancode == KEY_ESCAPE:
		emit_signal("finished")


func close():
	$AnimationPlayer.play("close")
	
func open():
	$AnimationPlayer.play("open")


func _on_AnimationPlayer_animation_finished(_anim_name):
	emit_signal("finished")
