"""
Commonly used Utility methods.
Math, Distance, etc.

"""

extends Node


func get_closest_object(group : Array, referenceObj : Node2D ) -> Node2D :
	var refPos = referenceObj.global_position
	var closest_object = null
	for obj in group:
		if is_instance_valid(obj) and obj != referenceObj and obj.is_inside_tree():
			var objPos = obj.global_position
			if closest_object == null or objPos.distance_squared_to(refPos) < closest_object.global_position.distance_squared_to(refPos):
				closest_object = obj
	return closest_object

func get_enemies_from_list(group : Array, referenceMech : Node2D) -> Node2D:
	var enemies = []
	for mech in group:
		if mech.team != referenceMech.team:
			enemies.push_back(mech)
	return enemies
	
	
