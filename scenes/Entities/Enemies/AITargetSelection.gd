"""
AI Have teams.

At intervals, select a new target from a different team.
Note, this is different than the AITargettingCursor.

This is primarily for where to navigate.
The targetting cursor will most likely shoot whatever's closest.


"""

extends Node2D

var mech
var current_target

# Called when the node enters the scene tree for the first time.
func _ready():
	var timer = get_tree().create_timer(0.66)
	yield(timer, "timeout")
	select_new_target()

func init(myMech):
	mech = myMech
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func select_new_target():
	var possible_targets = get_tree().get_nodes_in_group("enemies")
	possible_targets.erase(mech)
	if Global.player != null:
		if mech.team != Global.player.team:
			possible_targets.push_back(Global.player)
	
	var enemy_targets = []
	for target in possible_targets:
		if target.team != mech.team:
			enemy_targets.push_back(target)
			
	# grab one randomly for now, but it might be better to look for the closest
	
	if enemy_targets.size() > 0:
		set_target( enemy_targets[randi()%enemy_targets.size()] )



func set_target(target):
	# public method. Anyone could override your random targetting.
	current_target = target
	mech.currently_targetted_enemy_mech = target

func get_target():
	return current_target

func _on_NewTargetAcquisitionTimer_timeout():
	select_new_target()
