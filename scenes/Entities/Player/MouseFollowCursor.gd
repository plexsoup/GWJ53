"""
Cursor (target reticle) follows mouse. Pretty simple
"""

extends Sprite

export var speed : float = 100.0

var mech


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.player_cursor = self
	

func seek_nearest_enemy(delta):
	var enemies = get_tree().get_nodes_in_group("enemies")
	var closest_enemy = Utils.get_closest_object(enemies, mech)
	var myPos = get_global_position()
	var enemyPos
	if closest_enemy != null:
		enemyPos = closest_enemy.get_global_position()
		#set_global_position(enemyPos)
		set_global_position(myPos.linear_interpolate(enemyPos, 0.9 * delta * speed))
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.auto_targetting == true:
		seek_nearest_enemy(delta)
	else:
		set_global_position(get_global_mouse_position())

