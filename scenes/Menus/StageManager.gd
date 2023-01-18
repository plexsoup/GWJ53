extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$SplashImage.show()
	Global.stage_manager = self
	
func change_scene(scenePathStr : String):
	var packedScene = load(scenePathStr)
	change_scene_to(packedScene)
	
func change_scene_to(packedScene):


	$GarageDoorsTransition.close()
	yield($GarageDoorsTransition, "finished")

	for scene in $SceneContainer.get_children():
		scene.queue_free()

	var newScene = packedScene.instance()
	$SceneContainer.add_child(newScene)
	
	$GarageDoorsTransition.open()


func start_next_battle(playerObj):
	
	var battleIdx = Global.battles_completed.size() % Global.battles.size()
	
	var battleName = Global.battles[battleIdx]
	change_scene(Global.battle_scenes[battleName])
	Global.battles_completed.append(battleName)





# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
