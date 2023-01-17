"""
Player Battle Mech for top-down shooting inherits from Entity
"""

extends "res://scenes/Entities/Entity.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.player = self
	
func die_for_real_this_time():
	print("You lose!")

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
