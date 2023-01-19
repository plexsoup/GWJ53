"""
Player Battle Mech for top-down shooting inherits from Entity
"""

extends "res://scenes/Entities/Entity.gd"


export var lose_scene_path : String



	
func custom_ready():
	Global.player = self
	knockback_resistance = 0.8
	
	if $Locomotion.get_child_count() == 0:
		var legScene = load("res://scenes/Entities/Parts/Mobility/BasicLegs.tscn").instance()
		$Locomotion.add_child(legScene)

func die_for_real_this_time():
	Global.money += Global.current_scene.cash_for_losing
	print("You lose!")
	
	Global.stage_manager.change_scene(lose_scene_path)
	

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_fight_started():
	$Camera2D.zoom_into_battle()
	
	
