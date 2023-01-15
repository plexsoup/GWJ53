extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.current_scene = self


func init(playerScene):
	$Entities.add_child(playerScene)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
