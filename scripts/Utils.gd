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
	for object in group:
		if object.has_method("get_team") and object.team != referenceMech.team:
			# static body walls might get included in the list accidentally, but they won't have a team.
			enemies.push_back(object)
	return enemies
	
	
