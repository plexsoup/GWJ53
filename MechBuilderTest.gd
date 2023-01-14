extends Control

onready var builder = $MechBuilder

func _ready():
	var hull_part = preload("res://scenes/Entities/Parts/Hull/L1Hull.tres")
	builder.add_part_to_list(hull_part)
	var wheels_part = preload("res://scenes/Entities/Parts/Mobility/Wheels.tres")
	builder.add_part_to_list(wheels_part)
	var dummy_part = Part.new()
	dummy_part.icon = preload("res://icon.png")
	dummy_part.name = "Test part"
	dummy_part.description = "Nothing to see here"
	var laser_part = preload("res://scenes/Entities/Parts/Laser/BasicLaser.tres")
	for i in 4:
		builder.add_part_to_list(laser_part)
	for i in 10:
		builder.add_part_to_list(dummy_part)
