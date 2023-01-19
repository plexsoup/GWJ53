extends Node2D

var mech : KinematicBody2D

export var speed : float = 600.0
export var acceleration : float = 5.0 # per second
export var deceleration : float = 25.0

var previous_velocity : Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("idle")

var ticks : int = 0

func init(myMech):
	mech = myMech
	if !mech.is_human_player: # AI no footsteps!
		$FootstepNoise.set_stream(null)





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
	var velocity = Vector2.ZERO
		
	if mech != null and mech.State ==  mech.States.READY:
		if mech.input_controller.pressed["move_forwards"] == true:
			velocity += Vector2.UP
		if mech.input_controller.pressed["move_right"] == true:
			velocity += Vector2.RIGHT
		if mech.input_controller.pressed["move_backwards"] == true:
			velocity += Vector2.DOWN
		if mech.input_controller.pressed["move_left"] == true:
			velocity += Vector2.LEFT
		var desired_velocity = velocity * speed / global_scale.x 
		var new_velocity = Vector2.ZERO
		if desired_velocity.length_squared() > previous_velocity.length_squared():
			new_velocity = lerp(previous_velocity, desired_velocity, acceleration*delta)
		else:
			new_velocity = lerp(previous_velocity, desired_velocity, deceleration*delta)
		
		#change_animation_if_required(new_velocity)
		velocity = new_velocity
		previous_velocity = new_velocity

	return velocity

	
	
	

func _on_started_walking(velocity):
	$AnimationPlayer.stop()
	$AnimationPlayer.play("walk")
	if velocity.x < 0:
		$LegPivot.scale.x = -1.0
	else:
		$LegPivot.scale.x = 1.0

func _on_stopped_walking(_velocity):
	$AnimationPlayer.stop()
	$AnimationPlayer.play("idle")


