extends KinematicBody2D

var speed = 200.0


func _process(_delta):
	var velocity = Vector2.ZERO
	velocity += $PathfindToPlayer.get_next_point().normalized() * speed

	#warning-ignore:RETURN_VALUE_DISCARDED
	move_and_slide( velocity )

