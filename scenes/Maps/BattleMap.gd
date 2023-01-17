extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.current_scene = self
	init(Global.player)

func init(playerScene): # called by MechBuilderTest when user presses finished
	playerScene.set_scale(Vector2(0.33, 0.33))
	$YSort/Entities.add_child(playerScene)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
