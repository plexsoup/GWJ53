"""

Drop this Node onto an enemy that needs to find the player.
in _process, call $PathfindToPlayer.get_next_point()

"""

extends Node2D


var current_path
var local_path
var next_point : Vector2
var target : Node2D
export var flocking : bool = false
export var peer_consider_distance : float = 2500.0
export var peer_avoid_distance : float = 850.0

var mech

var flocking_vector : Vector2 = Vector2.ZERO
var wall_avoid_vector : Vector2 = Vector2.ZERO

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
	if mech != null and mech.State in [mech.States.READY, mech.States.INVULNERABLE]:

		#update()
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
		
		
	if !is_instance_valid(target) or target.State == target.States.DYING:
		return

	var level_navigation_map = get_world_2d().get_navigation_map()
	if level_navigation_map == null:
		return
	var optimize = true
	current_path = Navigation2DServer.map_get_path(level_navigation_map, self.get_global_position(), target.global_position, optimize)

	local_path = translate_points_to_local(current_path)
	$VisualizationLine2D.points = local_path

	update_virtual_controller_buttons()

	

func get_flocking_vector():
	var new_flocking_vector = Vector2.ZERO
	var teammates = Utils.get_teammates(mech.team)
	var cohesion_vector = Vector2.ZERO
	var alignment_vector = Vector2.ZERO
	var avoidance_vector = Vector2.ZERO
	
	teammates.erase(self.mech)

	# drop distant teammates
	var nearby_teammates = []
	for teammate in teammates:
		var culling_range = peer_consider_distance
		if global_position.distance_squared_to(teammate.global_position) < culling_range * culling_range:
			nearby_teammates.push_back(teammate)
	
	for teammate in nearby_teammates:
		cohesion_vector += teammate.global_position
		alignment_vector += teammate.get_velocity()
		var avoidance_distance = peer_avoid_distance
		if teammate.global_position.distance_squared_to(self.mech.global_position) < avoidance_distance * avoidance_distance:
			avoidance_vector += teammate.global_position - self.mech.global_position
	
	if nearby_teammates.size() > 1: # if there are more than 2 teammates, average the vectors
		cohesion_vector /= float(nearby_teammates.size())
		alignment_vector /= float(nearby_teammates.size())
		cohesion_vector -= self.mech.global_position
		#alignment_vector -= self.mech.velocity
		cohesion_vector = cohesion_vector.normalized()
		alignment_vector = alignment_vector.normalized()
		avoidance_vector = avoidance_vector.normalized()
	new_flocking_vector = cohesion_vector + alignment_vector + (1.5 * avoidance_vector) / 3.5
	return new_flocking_vector # just returns a value, doesn't update global var, flocking_vector



func update_virtual_controller_buttons():
	var targetVec = next_point.normalized()
	targetVec += wall_avoid_vector.normalized()

	if flocking:
		targetVec += flocking_vector.normalized()
		targetVec /= 3.0
	else:
		targetVec /= 2.0
	

	for buttonName in ["move_right", "move_left", "move_forwards", "move_backwards"]:
		pressed[buttonName] = false
		
	if targetVec.x > 0:
		pressed["move_right"] = true
	elif targetVec.x < 0:
		pressed["move_left"] = true
	if targetVec.y > 0:
		pressed["move_backwards"] = true
	elif targetVec.y < 0:
		pressed["move_forwards"] = true
		
	
func is_any_movement_key_pressed():
	var movementPressed = false
	for buttonName in ["move_right", "move_left", "move_forwards", "move_backwards"]:
		if pressed[buttonName] == true:
			movementPressed = true
	return movementPressed
	
	
func set_target(newTarget):
	target = newTarget
	
func get_next_point():
	return next_point
	


func _on_NavUpdateTimer_timeout():
	update_nav()
	if flocking:
		flocking_vector = get_flocking_vector()


func _on_wall_detected(direction):
	wall_avoid_vector = -direction

func _on_wallradar_all_clear():
	wall_avoid_vector = Vector2.ZERO

#func _draw():
#	draw_circle(Vector2.ZERO, peer_avoid_distance, Color(0.8, 0.3, 0.0, 0.25))
#	draw_circle(Vector2.ZERO, peer_consider_distance, Color(0.2, 0.2, 0.2, 0.15))
#
