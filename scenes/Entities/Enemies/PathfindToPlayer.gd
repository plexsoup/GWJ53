"""

Drop this Node onto an enemy that needs to find the player.
in _process, call $PathfindToPlayer.get_next_point()

"""

extends Node2D


var current_path
var local_path
var next_point : Vector2
var target : Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(_delta):
	if current_path != null:
		if current_path.size() > 1:
			next_point = local_path[1] # look ahead an extra step


func translate_points_to_local(pointsArr):
	var newArr = []
	for point in pointsArr:
		newArr.push_back(point - get_global_position())
	return newArr

func update_nav():
	var level_navigation_map = get_world_2d().get_navigation_map()
	if level_navigation_map == null:
		return
	var optimize = true
	
	if target == null:
		target = Global.player
	current_path = Navigation2DServer.map_get_path(level_navigation_map, self.get_global_position(), target.global_position, optimize)

	local_path = translate_points_to_local(current_path)
	$VisualizationLine2D.points = local_path




func set_target(newTarget):
	target = newTarget
	
func get_next_point():
	return next_point
	


func _on_NavUpdateTimer_timeout():
	update_nav()
