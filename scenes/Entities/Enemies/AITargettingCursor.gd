"""
Cursor moves onto the closest enemy, so weapons can point toward it.
"""

extends Sprite

export var speed : float = 50.0
var mech
var nearest_enemy

# Called when the node enters the scene tree for the first time.
func _ready():
	var timer = get_tree().create_timer(0.5)
	yield(timer, "timeout")
	mech = get_parent().mech
	
	mech.targetting_cursor = self
	if mech.team > -1:
		set_modulate(Global.team_colors[mech.team])

func identify_nearest_enemy():
	# find the nearest mech that's not on your team and hover over them.

	var all_mechs = get_tree().get_nodes_in_group("enemies")
	
	if is_instance_valid(Global.player):
		all_mechs.push_back(Global.player)
	var enemy_mechs = []
	
	# remove the mechs on my team
	for singleMech in all_mechs:
		if singleMech.team != mech.team and singleMech.State != singleMech.States.DEAD:
			enemy_mechs.push_back(singleMech)
	
	var closest_enemy = Utils.get_closest_object(enemy_mechs, self)
	nearest_enemy = closest_enemy



func follow_nearest_enemy(delta):
	if nearest_enemy != null:
		var myPos = get_global_position()
		var enemyPos
		if is_instance_valid(nearest_enemy):
			enemyPos = nearest_enemy.get_global_position()
			set_global_position(myPos.linear_interpolate(enemyPos, 0.9 * delta * speed))

	
func _process(delta):
	follow_nearest_enemy(delta)



func _on_Timer_timeout():
	if mech == null:
		mech = get_parent().mech
	identify_nearest_enemy()
