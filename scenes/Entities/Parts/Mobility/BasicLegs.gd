extends Node2D

var mech : KinematicBody2D

export var speed : float = 150.0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func init(myMech):
	mech = myMech


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func move(delta):
	if mech.State ==  mech.States.READY:
	
		if mech == null or mech.State == mech.States.DEAD:
			return
		var velocity = get_velocity(delta)
		#warning-ignore:RETURN_VALUE_DISCARDED
		mech.move_and_slide(velocity * Global.game_speed)

func get_velocity(_delta):
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
		return velocity * speed / global_scale.x 
	
