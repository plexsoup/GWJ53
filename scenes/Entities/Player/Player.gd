"""
Player Battle Mech for top-down shooting inherits from Entity
"""

extends "res://scenes/Entities/Entity.gd"


export var lose_scene_path : String



	
func custom_ready():
	Global.player = self
	knockback_resistance = 0.8
	
	provide_free_parts()

	
func provide_free_parts():
	if $Locomotion.get_child_count() == 0:
		var legScene = load("res://scenes/Entities/Parts/Mobility/BasicLegs.tscn").instance()
		$Locomotion.add_child(legScene)
		$Locomotion.set_visible(false)
		speed_fudge_factor = 0.5

	if $Weapons.get_child_count() == 0:
		var laserScene = load("res://scenes/Entities/Parts/Laser/PenetratingLaser.tscn").instance()
		$Weapons.add_child(laserScene)
	
		

	set_state(States.PAUSED)

func die_for_real_this_time():
	Global.money += Global.current_scene.cash_for_losing
	print("You lose!")
	
	Global.stage_manager.change_scene(lose_scene_path)
	

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_fight_started():
	$Camera2D.zoom_into_battle()
	set_state(States.READY)
	


func _on_Player_tree_exiting():
	set_state(States.PAUSED)
