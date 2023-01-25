"""
A class for defining a Mech. This is the class passed from the mech builder scene to 
The shootemup scene.
"""

extends Reference
class_name MechStructure

var inner_parts := []

class MechStructurePart:
	var part : Part
	var position : Vector2
	var connected_parts := []


func create_entity(base_entity : PackedScene):
	var entity
	if base_entity == null:
		entity = preload("res://scenes/Entities/Entity.tscn").instance()
	else:
		entity = base_entity.instance()
	var mech_parts = {}
	for mech_structure_part in inner_parts:
		mech_structure_part = mech_structure_part as MechStructurePart
		var part = mech_structure_part.part as Part
		entity.armor_max += part.armor
		entity.health_max += part.health
		entity.shield_max += part.shield
		var mech_part : MechPart
		if part.mech_part != null:
			mech_part = part.mech_part.instance()
		else:
			var spr =  Sprite.new()
			spr.texture = part.icon
			mech_part = spr
		mech_parts[mech_structure_part] = mech_part
		
		var mech_part_parent : Node2D
		match part.type:
			Part.Type.HULL:
				mech_part_parent = entity.get_node("Health")
			Part.Type.MOBILITY:
				mech_part_parent = entity.get_node("Locomotion")
			Part.Type.UTILITY:
				mech_part_parent = entity.get_node("Engine")
			Part.Type.WEAPON:
				mech_part_parent = entity.get_node("Weapons")
		mech_part.position = mech_structure_part.position
		mech_part_parent.add_child(mech_part)
		var collision_shape = CollisionShape2D.new()
		var circle = CircleShape2D.new()
		circle.radius = 64
		collision_shape.shape = circle
		entity.add_child(collision_shape)
		collision_shape.position = mech_part.position
		
#		if mech_structure_part.part.type == Part.Type.MOBILITY:
#			mech_part.dont_bounce = true
		
		for connected_part in mech_structure_part.connected_parts:
			#Add visual struts
			var strut = preload("res://scenes/MechBuilder/Strut.tscn").instance()
			entity.get_node("Struts").add_child(strut)
			var strut_len = mech_part.position.distance_to(connected_part.position)
			strut.length = strut_len
			strut.position = mech_part.position
			strut.rotation = (connected_part.position - mech_part.position).angle()
			
			#Add strut colliders
			var strut_collider = CollisionShape2D.new()
			var box = RectangleShape2D.new()
			box.extents = Vector2(strut_len/2, 64)
			strut_collider.shape = box
			strut_collider.position = (mech_part.position + connected_part.position) * 0.5
			strut_collider.rotation = strut.rotation
			entity.add_child(strut_collider)
	
	#Add bouncy part connections
	# This is where my poor naming conventions come back to bite me
	
	# make a copy of the inner parts so we don't modify the mech structure
	var part_ref = []
	var equivalent_part = {}
	var original_part = {}
	for part in inner_parts:
		var new_part = MechStructurePart.new()
		new_part.part = part.part
		new_part.position = part.position
		equivalent_part[part] = new_part
		original_part[new_part] = part
		part_ref.append(new_part)
	
	# make the connections 2 way
	for part in inner_parts:
		for c in part.connected_parts:
			equivalent_part[part].connected_parts.append(equivalent_part[c])
			equivalent_part[c].connected_parts.append(equivalent_part[part])
	
	
	# put the locomotive parts in a list, and then branch out connections from them as the roots
	var parts_for_connection := []
	for part in part_ref:
		if part.part.type == Part.Type.MOBILITY:
			parts_for_connection.append(part)
	
	var i = 0
	while i < parts_for_connection.size():
		var part : MechStructurePart = part_ref[i]
		for c in part.connected_parts:
			if not c in parts_for_connection:
				parts_for_connection.append(c)
			if c.part.type == Part.Type.MOBILITY:
				continue
			var mech_part = mech_parts[original_part[part]]
			var c_mech_part = mech_parts[original_part[c]]
			
			# prevent 2 way spring connections (I think this will make it wavier)
			var already_connected = false
			for pc in mech_part.part_connections:
				if pc.parent_part == c_mech_part:
					already_connected = true
					break
			if already_connected: continue
			
			var connection = MechPart.PartConnection.new()
			connection.parent_part = mech_part
			connection.offset = c.position - part.position
			c_mech_part.part_connections.append(connection)
		i += 1
			
		
	return entity
