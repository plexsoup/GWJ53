"""
Design team wants last-man-standing arena battles.
So the scene should give a win condition after
	- all enemies have spawned
	- and no enemies remain.

"""

extends Node

enum Win_Requirements { TIME, KILL_COUNT, LAST_SURVIVOR }
export (Win_Requirements) var win_requirement = Win_Requirements.LAST_SURVIVOR

export var time_to_win : float
export var enemies_to_kill : int


var battle_scene

signal player_won

# Called when the node enters the scene tree for the first time.
func _ready():
	
	# wait for ancestors to be enter the scene tree
	var timer = get_tree().create_timer(0.5)
	yield(timer, "timeout")
	
	if win_requirement == Win_Requirements.TIME:
		$WinCheckTimer.set_wait_time()
	
	delayed_ready()

func delayed_ready():
	battle_scene = get_parent()
	if battle_scene.has_method("_on_player_won"):
		#warning-ignore:RETURN_VALUE_DISCARDED
		connect("player_won", battle_scene, "_on_player_won")
	else:
		printerr("Configuration error in " + battle_scene.name + ", requires _on_player_won() method.")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func check_win_conditions():
	#var win_conditions_met = false
	if win_requirement == Win_Requirements.LAST_SURVIVOR:
		
		var enemies_remain = false
		if battle_scene.get("done_initial_spawns") == true:
			var possible_enemies = get_tree().get_nodes_in_group("enemies")
			for enemy in possible_enemies:
				if enemy.State != enemy.States.DEAD:
					enemies_remain = true
			return !enemies_remain
		else: # still spawning enemies
			return false
	elif win_requirement == Win_Requirements.TIME:
		return $WinCheckTimer.is_stopped()
	elif win_requirement == Win_Requirements.KILL_COUNT:
		# ???
		# who keeps track?
		printerr("Missing code in CheckWinConditions.gd. Win by Killcount isn't implemented")


func _on_WinCheckTimer_timeout():
	if check_win_conditions() == true:
		emit_signal("player_won")
		disconnect("player_won", battle_scene, "_on_player_won")
		$WinCheckTimer.stop()
	
