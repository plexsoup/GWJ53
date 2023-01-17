"""

Generic spawner, 
- spawn anything at intervals

- useful for spawning other spawners to make spawns of entities
- put things to be spawned in SpawnSupply

"""

extends Node2D

export var num_spawns_per_interval : int = 1
export var time_between_spawns : float = 5.0
export var max_spawns : int = 1
export var die_on_completion : bool = true
export var slow_death : bool = false
export var spawn_randomly : bool = false # if true, walk down the list of available spawns in an orderly fashion
export var team : int = -1 setget set_team, get_team

var current_spawn_num : int = 0
var active_spawns = [] # array of object refs in case we need it for flocking or running patterns

signal finished

signal died

# Called when the node enters the scene tree for the first time.
func _ready():
	$SpawnTimer.set_wait_time(time_between_spawns)
	$SpawnTimer.start()
	custom_ready()

func register_callback(callbackObj, callbackMethod):
	# does anyone care if we die?
	if callbackObj != null:
		#warning-ignore:RETURN_VALUE_DISCARDED
		connect("died", callbackObj, callbackMethod)
	

func custom_ready():
	# override this method in inherited scenes
	pass

func set_team(newTeam):
	team = newTeam
	
func get_team():
	return team


func get_next_spawn_name(spawnNum):
	var ratio = float(spawnNum)/float(max_spawns)
	var spawnIdx = int(float($SpawnSupply.get_resource_list().size()-1) * ratio)
	return $SpawnSupply.get_resource_list()[spawnIdx]


func get_random_spawn_name():
	var spawnNamesList = $SpawnSupply.get_resource_list()
	var spawnNum = randi()%spawnNamesList.size()
	return spawnNamesList[spawnNum]


func spawn_something(spawnNum : int = -1):
	# if there's a bunch of things in the pool, grab one randomly
	# later on we can figure out how to implement linear game progression
	
	var spawnName
	if spawn_randomly or spawnNum == -1 or spawnNum == null:
		spawnName = get_random_spawn_name()
	else:
		spawnName = get_next_spawn_name(spawnNum)
		
	var spawn = $SpawnSupply.get_resource(spawnName).instance()
	if spawn.has_method("register_callback"):
		spawn.register_callback(self, "_on_spawn_died")

	if Global.current_scene.has_node("Spawners"):
		Global.current_scene.get_node("Spawners").add_child(spawn)
	else:
		get_parent().add_child(spawn)
	spawn.set_global_position(get_global_position())

	if spawn.has_method("set_team"):
		spawn.set_team(team)

	current_spawn_num += 1
	if current_spawn_num < max_spawns:
		$SpawnTimer.start()
	else:
		print(self.name + " finished spawning")
		emit_signal("finished")


func die():
	emit_signal("died")
	if slow_death == false:
		call_deferred("queue_free")
	else:
		$Appearance/Sprite.hide()
		$DeathViz.start_dying(self, "_on_DeathViz_finished")
		

func _on_SpawnTimer_timeout():
	if current_spawn_num < max_spawns:
		spawn_something(num_spawns_per_interval)


func _on_spawn_died(spawnObj):
	active_spawns.erase(spawnObj)
	if active_spawns.size() == 0 and die_on_completion == true:
		die()

		
func _on_DeathViz_finished():
	call_deferred("queue_free")
	




