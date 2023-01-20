"""
Basic missile launcher.
Might track the mouse, or maybe autotargets.

Spawns a projectile which deals damage on impact.

To meet accessibility requirements:
	Every weapon needs a mouselook targetted attack and an autotarget.


"""

extends Node2D

var mech
export var projectile_range : float = 200.0
export var damage : float = 500.0
export (Global.damage_types) var damage_type : int = Global.damage_types.LASER
export var line_of_sight : bool = false

export var shots_per_burst : int = 1
export var burst_delay : float = 0.5
export var reload_time : float = 1.0

var shots_left : int = shots_per_burst



export var projectile : PackedScene


enum States { RELOADING, COCKING }
var State = States.RELOADING

var target_locked : Node2D # probably a kinematic body



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	$ReloadTimer.start()
	$MissileLauncherSprite/MuzzleFlash.visible = false

	$CockDurationTimer.set_wait_time(burst_delay)
	$ReloadTimer.set_wait_time(reload_time)

func init(myMech):
	mech = myMech


func scene_finished():
	if Global.current_scene.State == Global.current_scene.States.FINISHED:
		return true


func shoot():
	if scene_finished():
		return

	if mech.State in [ mech.States.READY, mech.States.INVULNERABLE ]:
		
		# WIP we should ask the target acquisition system for a target
		if mech != null and mech.State in [ mech.States.READY, mech.States.INVULNERABLE ]:
			shots_left -= 1
			if shots_left == 0:
				State = States.RELOADING
				$ReloadTimer.start()
			else:
				State = States.COCKING
				$CockDurationTimer.start()
		
			make_noise()
			flash_muzzle()
			spawn_projectile()
	else: # wait a bit.
		$ReloadTimer.start()



func spawn_projectile():
	var newProjectile = projectile.instance()
	var targetPos = mech.targetting_cursor.global_position
	newProjectile.init(mech, damage, damage_type, projectile_range, line_of_sight, targetPos)

	if Global.current_scene != null:
#		if Global.current_scene.has_node("YSort/Projectiles"):
#			Global.current_scene.get_node("Ysort/Projectiles").add_child(newProjectile)
		Global.current_scene.add_child(newProjectile)
		newProjectile.global_position = $MissileLauncherSprite/MuzzleLocation.global_position
		newProjectile.global_rotation = $MissileLauncherSprite.global_rotation

func make_noise():
	$ShootNoise.set_pitch_scale(rand_range(0.8, 1.2))
	$ShootNoise.play()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	aim(delta)
	

func aim(_delta):

	#if Global.player_cursor != null:
	if mech.targetting_cursor != null:
		var myPos = self.global_position
		var cursorPos = mech.targetting_cursor.get_global_position() # note, cursor might be on autopilot depending on Global.auto_targetting
		var targetPos = cursorPos
		if myPos.distance_squared_to(cursorPos) > projectile_range * projectile_range:
			targetPos = myPos.direction_to(cursorPos)*projectile_range
		else:
			targetPos = cursorPos - myPos
			
		$MissileLauncherSprite.look_at(targetPos + myPos)
		


func flash_muzzle():
	if has_node("AnimationPlayer"):
		if $AnimationPlayer.has_animation("flash"):
			$AnimationPlayer.play("flash")
		else:
			print("no flash animation")



func _on_ReloadTimer_timeout():
	shots_left = shots_per_burst
	shoot()

func _on_CockDurationTimer_timeout():
	
	shoot() # shoot method restarts the CockDurationTimer or ReloadTimer




		
			
	
