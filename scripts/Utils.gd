"""
Commonly used Utility methods.
Math, Distance, etc.

"""

extends Node


func get_closest_object(group : Array, referenceObj : Node2D ) -> Node2D :
	group.erase(referenceObj)
	var refPos = referenceObj.global_position
	var closest_object = null
	for obj in group:
		if is_instance_valid(obj) and obj.is_inside_tree():
			var objPos = obj.global_position
			if closest_object == null or refPos.distance_squared_to(objPos) < refPos.distance_squared_to(closest_object.global_position):
				closest_object = obj
				
	return closest_object

func get_enemies_from_list(group : Array, referenceMech : Node2D) -> Node2D:
	var enemies = []
	for object in group:
		if object.has_method("get_team") and object.team != referenceMech.team:
			# static body walls might get included in the list accidentally, but they won't have a team.
			enemies.push_back(object)
	return enemies

func get_teammates(team):
	var mechs = get_tree().get_nodes_in_group("enemies")
	if Global.player != null:
		mechs.push_back(Global.player)
	var teammates = []
	for mech in mechs:
		if mech.team == team:
			teammates.push_back(mech)
	return teammates

	
