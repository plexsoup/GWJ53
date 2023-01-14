"""
Take all the regular inputs from Input.is_action_pressed()
and map them to a dictionary, which is the
same for humans and AI mechs.

Locomotion nodes should look to Input nodes to see when they should move.
"""

extends Node2D

var inputs = [ "move_left", "move_right", "move_forwards", "move_backwards", "shoot_primary", "shoot_alternate", "jump"]

var pressed = {}

var mech : KinematicBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	for inputName in inputs:
		pressed[inputName] = false



func init(myMech):
	mech = myMech
	mech.input_controller = self
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _unhandled_input(event):
	if mech != null and mech.State == mech.States.READY:
		if mech.is_human_player:
			for inputName in inputs:
				if Input.is_action_pressed(inputName):
					pressed[inputName] = true
				else:
					pressed[inputName] = false
				
		else:
			printerr("Human input on non-human player. " + self.name + " on " + owner.name)
			
