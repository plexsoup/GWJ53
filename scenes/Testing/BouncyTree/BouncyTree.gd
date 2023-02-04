extends Node2D

var connection_radius = 100
var spring = 10
var damp = 10

class BouncyPart:
	var position : Vector2
	var velocity : Vector2
	var connections := []

class Connection:
	var parent_part : BouncyPart
	var offset : Vector2

var bouncy_parts = []
var root : BouncyPart

func _input(event):
	if event.is_action_pressed("place_part"):
		var bouncy_part = BouncyPart.new()
		bouncy_part.position = event.position
		for part in bouncy_parts:
			if bouncy_part.position.distance_to(part.position) < connection_radius:
				var connection = Connection.new()
				connection.parent_part = part
				connection.offset = bouncy_part.position - part.position
				bouncy_part.connections.append(connection)
		bouncy_parts.append(bouncy_part)
		if !root:
			root = bouncy_part
	
	if root and event is InputEventMouseMotion and Input.is_key_pressed(KEY_SPACE):
		root.position += event.relative

func _process(delta):
	for part in bouncy_parts:
		part = part as BouncyPart
		if part.connections.empty():
			continue
		var target_pos = Vector2()
		for connection in part.connections:
			target_pos += (connection.parent_part.position + connection.offset)
		target_pos /= part.connections.size()
		var spring_force = target_pos - part.position
		part.velocity += spring_force * spring * delta
		part.velocity -= part.velocity * damp * delta
		part.position += part.velocity * delta
	
	update()


func _draw():
	draw_arc(get_global_mouse_position(), connection_radius, 0, TAU, 24, Color.white)
	
	for part in bouncy_parts:
		for connection in part.connections:
			draw_line(connection.parent_part.position, part.position, Color.darkkhaki, 4)
	
	for part in bouncy_parts:
		draw_circle(part.position, 10, Color.white)
