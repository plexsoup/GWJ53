extends Control

signal scene_transistion_finished()

# Called when the node enters the scene tree for the first time.
func _ready():
#	$SplashImage.show()
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
	yield($GarageDoorsTransition, "finished")
	emit_signal("scene_transistion_finished")


func start_next_battle(_playerObj):
	var battleIdx = Global.battles_completed.size() % Global.battles.size()
	var battleName = Global.battles[battleIdx]
	if battleName in Global.vs_hype_screens:
		change_scene(Global.vs_hype_screens[battleName])
		yield(self, "scene_transistion_finished")
		yield(get_tree().create_timer(3.5), "timeout")	
	change_scene(Global.battle_scenes[battleName])

func mark_battle_completed():
	var battleIdx = Global.battles_completed.size() % Global.battles.size()
	var battleName = Global.battles[battleIdx]
	Global.battles_completed.append(battleName)




# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
