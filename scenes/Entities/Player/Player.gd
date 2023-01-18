"""
Player Battle Mech for top-down shooting inherits from Entity
"""

extends "res://scenes/Entities/Entity.gd"


export var lose_scene_path : String



# Called when the node enters the scene tree for the first time.
func _ready():
	Global.player = self
	
func die_for_real_this_time():
	print("You lose!")
	
	Global.stage_manager.change_scene(lose_scene_path)
	

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
