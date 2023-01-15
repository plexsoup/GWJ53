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
		var mech_part : Node
		if part.mech_part != null:
			part.mech_part.instance()
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
		
	return entity
