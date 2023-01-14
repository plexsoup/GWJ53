extends Control

onready var builder = $MechBuilder

func _ready():
	var hull_res = preload("res://scenes/Entities/Parts/Hull/L1Hull.tres")
	builder.add_part_to_list(hull_res)
	var wheels_res = preload("res://scenes/Entities/Parts/Mobility/Wheels.tres")
	builder.add_part_to_list(wheels_res)
	var hull_res_2 = hull_res.duplicate()
	hull_res_2.icon = preload("res://icon.png")
	hull_res_2.name = "Giga hull"
	builder.add_part_to_list(hull_res_2)
