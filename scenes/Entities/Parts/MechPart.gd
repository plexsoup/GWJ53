extends Node2D
class_name MechPart
var disabled = false
var mech : KinematicBody2D

var dont_bounce = false
var velocity : Vector2
var previous_global_position : Vector2
var part_connections := []

class PartConnection:
	var parent_part : MechPart
	var offset : Vector2
	

func _process(delta):
	if name == "L1Hull":
		pass
	if part_connections.empty() or dont_bounce:
		return
	var target_pos = Vector2()
	for connection in part_connections:
		target_pos += connection.parent_part.global_position + connection.offset
	target_pos /= part_connections.size()
	var spring_vector = target_pos - previous_global_position
	velocity += spring_vector * delta * Global.part_spring
	velocity -= velocity * delta * Global.part_damp
	global_position = previous_global_position + velocity * delta
	previous_global_position = global_position
