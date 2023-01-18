extends Node2D


var done_initial_spawns : bool = false

enum States { SPAWNING, FIGHTING, PAUSED, FINISHED }
var State = States.SPAWNING

export var num_spawners : int = 1 # count the $Spawners children
var spawners_finished_spawning : int = 0
export var cash_for_winning : int = 10
export var cash_for_losing : int = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.current_scene = self
	init(Global.player)

	#num_spawners = $Spawners.get_child_count()
	for spawner in $Spawners.get_children():
		if spawner.has_signal("finished"):
			spawner.connect("finished", self, "_on_spawner_finished")

func init(playerScene): # called by MechBuilderTest when user presses finished
	playerScene.set_scale(Vector2(1.0, 1.0))
	$YSort/Entities.add_child(playerScene)
	
	
func _on_spawner_finished():
	
	spawners_finished_spawning += 1
	if spawners_finished_spawning >= num_spawners:
		State = States.FIGHTING
		done_initial_spawns = true
		
func _on_player_won():
	State = States.FINISHED
	Global.money += cash_for_winning
	if has_node("HUD"):
		$HUD.visible = true
		if $HUD.has_method("_on_player_won"):
			$HUD._on_player_won(cash_for_winning)
	else:
		printerr("Configuration error in BattleMap.gd for " + self.name + ". No HUD found.")

