"""

Drop this Node onto an enemy that needs to find the player.
in _process, call $PathfindToPlayer.get_next_point()

"""

extends Node2D


var current_path
var local_path
var next_point : Vector2
var target : Node2D

var mech

# for locomotion which relies in input controllers,
# store virtual button presses
var pressed = {
	"move_forwards":false,
	"move_backwards":false,
	"move_left":false,
	"move_right":false,
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func init(myMech):
	mech = myMech
	mech.input_controller = self
	
	
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
	if target == null:
		target = mech.currently_targetted_enemy_mech
		
		
	if !is_instance_valid(target) or target.State == target.States.DEAD:
		return

	var level_navigation_map = get_world_2d().get_navigation_map()
	if level_navigation_map == null:
		return
	var optimize = true
	current_path = Navigation2DServer.map_get_path(level_navigation_map, self.get_global_position(), target.global_position, optimize)

	local_path = translate_points_to_local(current_path)
	$VisualizationLine2D.points = local_path

	update_virtual_controller_buttons()

func update_virtual_controller_buttons():
	for buttonName in ["move_right", "move_left", "move_forwards", "move_backwards"]:
		pressed[buttonName] = false
		
	if next_point.x > 0:
		pressed["move_right"] = true
	elif next_point.x < 0:
		pressed["move_left"] = true
	if next_point.y > 0:
		pressed["move_backwards"] = true
	elif next_point.y < 0:
		pressed["move_forwards"] = true
		
	


func set_target(newTarget):
	target = newTarget
	
func get_next_point():
	return next_point
	


func _on_NavUpdateTimer_timeout():
	update_nav()
