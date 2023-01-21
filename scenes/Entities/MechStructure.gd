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
		
		for connected_part in mech_structure_part.connected_parts:
			var strut = preload("res://scenes/MechBuilder/Strut.tscn").instance()
			entity.get_node("Struts").add_child(strut)
			var strut_len = mech_part.position.distance_to(connected_part.position)
			strut.length = strut_len
			strut.position = mech_part.position
			strut.rotation = (connected_part.position - mech_part.position).angle()
			var strut_collider = CollisionShape2D.new()
			var box = RectangleShape2D.new()
			box.extents = Vector2(strut_len/2, 64)
			strut_collider.shape = box
			strut_collider.position = (mech_part.position + connected_part.position) * 0.5
			strut_collider.rotation = strut.rotation
			entity.add_child(strut_collider)
			
		
		
	return entity
