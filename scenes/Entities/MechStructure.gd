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
			strut.length = mech_part.position.distance_to(connected_part.position)
			strut.position = mech_part.position
			strut.look_at(connected_part.position)
			
			
		
		
	return entity
