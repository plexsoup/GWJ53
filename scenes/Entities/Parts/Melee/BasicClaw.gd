"""
Basic shock field
Area2D static hurtbox immediate effect.


"""

extends Node2D

var mech
export var projectile_range : float = 500.0

export var damage : float = 250.0
export (Global.damage_types) var damage_type : int = Global.damage_types.IMPACT

export var reload_time : float = 1.5

export var knockback_effect : float = 5.0


enum States { RELOADING, READY }
var State = States.RELOADING



# Called when the node enters the scene tree for the first time.
func _ready():
	$ReloadTimer.set_wait_time(reload_time)
	$ReloadTimer.start()


func init(myMech):
	mech = myMech



func scene_finished():
	
	if Global.current_scene.State == Global.current_scene.States.FINISHED:
		return true


func shoot():
	if scene_finished():
		return

	# WIP we should ask the target acquisition system for a target
	if mech != null and mech.State in [ mech.States.READY, mech.States.INVULNERABLE ]:
		State = States.RELOADING
		$ReloadTimer.start()
		make_noise()
		flash()
		hurt_targets()
	else:
		$ReloadTimer.start()


func hurt_targets():
	var blast = $Sprite/HurtBox
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
func _process(delta):
	aim(delta)
	
func aim(_delta):
	$Sprite.look_at(mech.targetting_cursor.global_position)



func flash():
	$AnimationPlayer.play("attack")


func _on_ReloadTimer_timeout():
	shoot()


func _on_CockDurationTimer_timeout():
	hurt_targets()

#
#func _on_BlastArea_body_entered(body):
#	if $ReloadTimer.is_stopped():
#		if body.has_method("get_team") and body.team != mech.team:
#			hurt_targets()
#			$AnimationPlayer.play("attack")
#			State = States.COCKING
#			$CockDurationTimer.start()
		
