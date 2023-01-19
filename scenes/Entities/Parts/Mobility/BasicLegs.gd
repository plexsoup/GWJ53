extends Node2D

var mech : KinematicBody2D

export var speed : float = 400.0
export var acceleration : float = 5.0 # per second
export var deceleration : float = 25.0

var previous_velocity : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func init(myMech):
	mech = myMech





# Entity now handles movement
#func move(delta):
#	if mech.State ==  mech.States.READY:
#
#		if mech == null or mech.State == mech.States.DEAD:
#			return
#		var velocity = get_velocity(delta)
#		#warning-ignore:RETURN_VALUE_DISCARDED
#		mech.move_and_slide(velocity * Global.game_speed)

func get_velocity(delta):
	if mech != null and mech.State ==  mech.States.READY:
		var velocity = Vector2.ZERO
		if mech.input_controller.pressed["move_forwards"] == true:
			velocity += Vector2.UP
		if mech.input_controller.pressed["move_right"] == true:
			velocity += Vector2.RIGHT
		if mech.input_controller.pressed["move_backwards"] == true:
			velocity += Vector2.DOWN
		if mech.input_controller.pressed["move_left"] == true:
			velocity += Vector2.LEFT
		var desired_velocity = velocity * speed / global_scale.x 
		var new_velocity
		if desired_velocity.length_squared() > previous_velocity.length_squared():
			new_velocity = lerp(previous_velocity, desired_velocity, acceleration*delta)
		else:
			new_velocity = lerp(previous_velocity, desired_velocity, deceleration*delta)
		previous_velocity = new_velocity
		return new_velocity
	

