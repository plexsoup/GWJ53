extends Node2D


signal finished

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func start_dying(callbackObj, callbackMethod):
	#warning-ignore:RETURN_VALUE_DISCARDED
	connect("finished", callbackObj, callbackMethod)
	$DeathTimer.start()
	if $AnimationPlayer.has_animation("die"):
		$AnimationPlayer.play("die")


func _on_DeathTimer_timeout():
	$Visualization/Corpse.show()
	$Visualization/DecayTimer.start()


func _on_DecayTimer_timeout():
	emit_signal("finished")
