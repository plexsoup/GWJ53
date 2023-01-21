"""
Basic shock field
Area2D static hurtbox immediate effect.


"""

extends MechPart

export var projectile_range : float = 500.0

export var damage : float = 1000.0
export (Global.damage_types) var damage_type : int = Global.damage_types.LASER
#export var line_of_sight : bool = false

export var shots_per_burst : int = 3
export var burst_delay : float = 0.33
export var reload_time : float = 1.5

export var knockback_effect : float = 20.0

var shots_left : int = shots_per_burst



export var projectile : PackedScene


enum States { RELOADING, COCKING }
var State = States.RELOADING

var target_locked : Node2D # probably a kinematic body




# Called when the node enters the scene tree for the first time.
func _ready():
	$CockDurationTimer.set_wait_time(burst_delay)
	$ReloadTimer.set_wait_time(reload_time)
	$ReloadTimer.start()


func init(myMech):
	mech = myMech



func scene_finished():
	
	if Global.current_scene.State == Global.current_scene.States.FINISHED:
		return true


func shoot():
	if scene_finished() or disabled:
		return

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
		flash()
		hurt_targets()
	else:
		$ReloadTimer.start()


func hurt_targets():
	var blast = $Sprite/BlastArea
	var potential_targets = blast.get_overlapping_bodies()
	var enemies = Utils.get_enemies_from_list(potential_targets, mech)
	var impactVector = (mech.targetting_cursor.get_global_position() - self.get_global_position()).normalized() * knockback_effect
	for enemy in enemies:
		if enemy.has_method("_on_hit"):
			enemy._on_hit(damage, impactVector, damage_type)
			
		


func make_noise():
	$ShootNoise.set_pitch_scale(rand_range(0.8, 1.2))
	$ShootNoise.play()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#aim(delta)
	pass




func flash():
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite, "modulate", Color.red, burst_delay)
	tween.tween_interval(burst_delay)
	tween.tween_property($Sprite, "modulate", Color.white, burst_delay/2.0)
	


func _on_ReloadTimer_timeout():
	shots_left = shots_per_burst
	shoot()

func _on_CockDurationTimer_timeout():
	shoot() # shoot method will subtract ammo and restart timers






