extends Control

onready var builder = $MechBuilder
export var fight_scene: PackedScene

func _ready():
	var hull_part = preload("res://scenes/Entities/Parts/Hull/L1Hull.tres")
	for i in 2: builder.add_part_to_list(hull_part)
	
	var wheels_part = preload("res://scenes/Entities/Parts/Mobility/Wheels.tres")
	for i in 2: builder.add_part_to_list(wheels_part)
	
	var legs_part = preload("res://scenes/Entities/Parts/Mobility/Legs.tres")
	for i in 2: builder.add_part_to_list(legs_part)
	
	var head_part = preload("res://scenes/Entities/Parts/Head/Head.tres")
	for i in 2: builder.add_part_to_list(head_part)

	var long_range_laser_part = preload("res://scenes/Entities/Parts/Laser/LongRangeLaser.tres")
	for i in 2:
		builder.add_part_to_list(long_range_laser_part)
	
	var penetrating_laser_part = preload("res://scenes/Entities/Parts/Laser/PenetratingLaser.tres")
	for i in 2:
		builder.add_part_to_list(penetrating_laser_part)
	
	var missile_launcher_part = preload("res://scenes/Entities/Parts/MissileLaunchers/BasicMissileLauncher.tres")
	for i in 2:
		builder.add_part_to_list(missile_launcher_part)
	
	
	
	var dummy_part = Part.new()
	dummy_part.icon = preload("res://icon.png")
	dummy_part.name = "Test part"
	dummy_part.description = "Nothing to see here"
	dummy_part.type = Part.Type.UTILITY
	var laser_part = preload("res://scenes/Entities/Parts/Laser/BasicLaser.tres")
	for i in 4:
		builder.add_part_to_list(laser_part)
	for i in 10:
		builder.add_part_to_list(dummy_part)
	

	
	builder.get_node("%FightButton").connect("pressed", self, "_on_fight_pressed")
	
func _on_fight_pressed():
	var mech_structure = builder.generate_mech_structure()
	var player = mech_structure.create_entity(preload("res://scenes/Entities/Player/Player.tscn"))
	builder.queue_free()
	
	if fight_scene != null:
		var new_arena = fight_scene.instance()
		add_child(new_arena)
		new_arena.init(player)

#	$TextureRect.show()
#	add_child(player)
