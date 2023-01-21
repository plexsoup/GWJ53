extends Node2D


export var speed = 10.0
signal wall(direction)
signal all_clear

var walls_detected = []

# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	
	var pathfinder = get_parent()
	if pathfinder.has_method("_on_wall_detected"):
		#warning-ignore:RETURN_VALUE_DISCARDED
		connect("wall", pathfinder, "_on_wall_detected")
		#warning-ignore:RETURN_VALUE_DISCARDED
		connect("all_clear", pathfinder, "_on_wallradar_all_clear")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation += speed * delta


	if $Ray.is_colliding():
		emit_signal("wall", Vector2.ONE.rotated(rotation))



func _on_PingTimer_timeout():
	if $Ray.is_colliding():
		walls_detected.push_back(Vector2.ONE.rotated(rotation))



func _on_ReportTimer_timeout():
	var averageWallVector : Vector2 = Vector2.ZERO
	if walls_detected.size > 0:
		for wallVec in walls_detected:
			averageWallVector += wallVec
		averageWallVector /= walls_detected.size()
		emit_signal("wall", averageWallVector, "_on_wall_detected")
	else:
		emit_signal("all_clear")
	walls_detected = []
	
