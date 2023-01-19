"""
Basic laser.
Might track the mouse, or maybe autotargets.

Only deal damage to the thing you're currently targetting.
No real need for collision shapes, since it doesn't penetrate.

To meet accessibility requirements:
	Every weapon needs a mouselook targetted attack and an autotarget.


"""

extends Node2D

var mech
#export var projectile : PackedScene
export var beam_range : float = 200.0
export var damage : float = 500.0
export (Global.damage_types) var damage_type : int = Global.damage_types.LASER
export var line_of_sight : bool = false

export var shot_duration : float = 1.0
export var reload_time : float = 1.5


enum States { RELOADING, SHOOTING }
var State = States.RELOADING

var target_locked : Node2D # probably a kinematic body

signal hit

# Called when the node enters the scene tree for the first time.
func _ready():
	vary_shot_timers(0.2)
	$ReloadTimer.start()

func vary_shot_timers(variation): # 0.0 to 1.0. Low is less variability
	$ShotDurationTimer.set_wait_time(rand_range(1.0-variation, 1.0+variation)*shot_duration)
	$ReloadTimer.set_wait_time(rand_range(1.0-variation, 1.0+variation)*reload_time)


func init(myMech):
	mech = myMech
	if mech == Global.player:
		damage *= 2.0

	if mech.is_in_group("enemies"):
		$TargetLocation/HurtBox.set_collision_mask_bit(0, true) # player
		$TargetLocation/HurtBox.set_collision_mask_bit(1, true) # enemies
		
	else: # player
		$TargetLocation/HurtBox.set_collision_mask_bit(1, true)
		$TargetLocation/HurtBox.set_collision_mask_bit(0, false)

	
	$RayCast2D.set_collision_mask_bit(0, true)
	$RayCast2D.set_collision_mask_bit(1, true)
	
	
	if line_of_sight:
		$RayCast2D.enabled = true
	else:
		$RayCast2D.enabled = false
		

func scene_finished():
	if Global.current_scene.State == Global.current_scene.States.FINISHED:
		return true
	

func shoot():
	if scene_finished():
		return
		
	# WIP we should ask the target acquisition system for a target
	if mech != null and mech.State == mech.States.READY:
		State = States.SHOOTING
		$TargetLocation/HurtBox.set_deferred("disabled", false)

		$Line2D.default_color.a = 0.66
		$ShotDurationTimer.start()
		make_noise()

func make_noise():
	$LaserNoise.set_pitch_scale(rand_range(0.8, 1.5))
	$LaserNoise.play()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	aim_laser(delta)
	

func aim_laser(_delta):
	if mech.targetting_cursor != null:
		var myPos = self.global_position
		var cursorPos = mech.targetting_cursor.get_global_position() # note, cursor might be on autopilot depending on Global.auto_targetting
		var targetPos = cursorPos
		if myPos.distance_squared_to(cursorPos) > beam_range * beam_range:
			targetPos = myPos.direction_to(cursorPos)*beam_range
		else:
			targetPos = cursorPos - myPos
			
		$LaserCannon.look_at(targetPos + myPos)
		if State == States.SHOOTING:
			var rescaled_target_pos = Vector2(targetPos.x / global_scale.x, targetPos.y / global_scale.y)
			$Line2D.points = [ Vector2.ZERO, rescaled_target_pos]
			if line_of_sight:
				$RayCast2D.set_cast_to(rescaled_target_pos)
				if $RayCast2D.is_colliding():
					$Line2D.points = [ Vector2.ZERO, self.to_local($RayCast2D.get_collision_point())]
			$TargetLocation.position = rescaled_target_pos
			$TargetLocation/CPUParticles2D.emitting = true
		else:
			$TargetLocation/CPUParticles2D.emitting = false


func _on_ReloadTimer_timeout():
	vary_shot_timers(0.2)

	shoot()



func _on_ShotDurationTimer_timeout():
	
	$Line2D.default_color.a = 0
	State = States.RELOADING
	$LaserNoise.stop()
	$TargetLocation/HurtBox.set_deferred("disabled", true)
	$ReloadTimer.start()


#func _on_HurtBox_body_entered(body):
#	if body != mech: # don't hurt yourself.
#		print(str(Time.get_ticks_msec()) + ": Target Acquired " + body.name  )
#		target_locked = body

		

func hurt_target(target):
	var impactVector = Vector2.ZERO # no knockback for beam weapon
	if target.has_method("_on_hit") and target.team != mech.team:
		#warning-ignore:RETURN_VALUE_DISCARDED
		connect("hit", target, "_on_hit")
		emit_signal("hit", damage, impactVector, damage_type)
		# disconnect signal so they don't keep taking hits after we target someone else
		disconnect("hit", target, "_on_hit")
			


func _on_DamageTicks_timeout():
	if State == States.SHOOTING:
		if line_of_sight == false: # hurtbox under cursor
			var possible_targets = $TargetLocation/HurtBox.get_overlapping_bodies()
			if possible_targets.size() > 0:
				for target in possible_targets:
					hurt_target(target)
		else: # raycast: first thing you touch
			var target = $RayCast2D.get_collider()
			if target and target.has_method("get_team") and target.team != mech.team:
				hurt_target(target)
				
			
	
