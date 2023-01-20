extends Node2D


var done_initial_spawns : bool = false

enum States { PREVIEW, SPAWNING, FIGHTING, PAUSED, FINISHED }
var State = States.PREVIEW

export var num_spawners : int = 1 # count the $Spawners children
var spawners_finished_spawning : int = 0
export var cash_for_winning : int = 10
export var cash_for_losing : int = 3

signal fight_started


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.current_scene = self
	var player = Global.player
	if player == null:
		player = load("res://scenes/Entities/Player/Player.tscn").instance()
	init(player)

	#num_spawners = $Spawners.get_child_count()
	for spawner in $Spawners.get_children():
		if spawner.has_signal("finished"):
			spawner.connect("finished", self, "_on_spawner_finished")

	

func init(playerScene): # called by MechBuilderTest when user presses finished
	playerScene.set_scale(Vector2(1.0, 1.0))
	
	if not playerScene.is_visible_in_tree():
		$YSort/Entities.add_child(playerScene)
	# wait until camera zoom 
	playerScene.State = playerScene.States.PAUSED


func get_spawner_teams_list() -> Array : # returns a list of team numbers in the battle
	var teams = []
	
	for spawner in $Spawners.get_children():
		if not spawner.team in teams:
			teams.push_back(spawner.team)

	return teams


	
func _on_spawner_finished():
	
	spawners_finished_spawning += 1
	if spawners_finished_spawning >= num_spawners:
		State = States.FIGHTING
		done_initial_spawns = true
		
func _on_player_won():
	State = States.FINISHED
	Global.money += cash_for_winning
	Global.stage_manager.mark_battle_completed()
	if has_node("HUD"):
		$HUD.visible = true
		if $HUD.has_method("_on_player_won"):
			$HUD._on_player_won(cash_for_winning)
	else:
		printerr("Configuration error in BattleMap.gd for " + self.name + ". No HUD found.")



func _on_OverviewPauseDuration_timeout():
	#warning-ignore:RETURN_VALUE_DISCARDED
	connect("fight_started", Global.player, "_on_fight_started")
	for spawner in $Spawners.get_children():
		#warning-ignore:RETURN_VALUE_DISCARDED
		connect("fight_started", spawner, "_on_fight_started")
		
	State = States.SPAWNING
	emit_signal("fight_started")
