extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.stage_manager = self
	
	
func change_scene_to(packedScene):


	$GarageDoorsTransition.close()
	yield($GarageDoorsTransition, "finished")

	for scene in $SceneContainer.get_children():
		scene.queue_free()

	var newScene = packedScene.instance()
	$SceneContainer.add_child(newScene)
	
	$GarageDoorsTransition.open()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
