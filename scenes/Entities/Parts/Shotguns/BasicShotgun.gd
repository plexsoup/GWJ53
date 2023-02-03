"""
Basic shotgun.
Area2D hurtbox immediate effect with particles.


"""

extends MechPart

export var projectile_range : float = 1500.0
var human_range_advantage : float = 1.25

export var damage : float = 200.0
export (Global.damage_types) var damage_type : int = Global.damage_types.LASER
#export var line_of_sight : bool = false

export var shots_per_burst : int = 4
export var burst_delay : float = 0.5
export var reload_time : float = 3.0
export var knockback_effect : float = 3.0

var shots_left : int = shots_per_burst



export var projectile : PackedScene


enum States { RELOADING, COCKING }
var State = States.RELOADING

var target_locked : Node2D # probably a kinematic body




# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	$ReloadTimer.start()
	$ShotgunSprite/MuzzleFlash.visible = false
	$CockDurationTimer.set_wait_time(burst_delay)
	vary_reload_time()

func vary_reload_time():
	$ReloadTimer.set_wait_time(reload_time * rand_range(0.75, 1.25))

func init(myMech):
	mech = myMech
	modify_hurtbox_size()

func modify_hurtbox_size():
	var default_blast_size = 1200 # reference size so we know how to scale up to projectile range
	if mech.is_human_player:
		projectile_range *= human_range_advantage
	
	$ShotgunSprite/MuzzleLocation/BlastArea/CollisionPolygon2D.scale.x = projectile_range / default_blast_size
	$ShotgunSprite/MuzzleLocation/BlastArea/BlastImage.scale.x = projectile_range/ default_blast_size

func scene_finished():
	if Global.current_scene.State == Global.current_scene.States.FINISHED:
		return true


func shoot():
	if scene_finished() or disabled:
		return

	if $ShotgunSprite/MuzzleLocation/BlastArea.has_method("update_polygon_shape"):
		$ShotgunSprite/MuzzleLocation/BlastArea.update_polygon_shape()
	# WIP we should ask the target acquisition system for a target
	if mech != null and mech.State in [ mech.States.READY, mech.States.INVULNERABLE ]:
		shots_left -= 1
		if shots_left == 0:
			State = States.RELOADING
			$ReloadTimer.start()
		else:
			State = States.COCKING
			$CockDurationTimer.start()
		make_noise("shoot")
		flash_muzzle()
		hurt_targets()
		
		#spawn_projectile()
	else:
		$ReloadTimer.start()

func hurt_targets():
	var blast = $ShotgunSprite/MuzzleLocation/BlastArea
	var potential_targets = blast.get_overlapping_bodies()
	var enemies = Utils.get_enemies_from_list(potential_targets, mech)
	var impactVector = (mech.targetting_cursor.get_global_position() - self.get_global_position()).normalized() * knockback_effect
	for enemy in enemies:
		if enemy.has_method("_on_hit"):
			enemy._on_hit(damage, impactVector, damage_type)
			
		


#func spawn_projectile():
#	var newProjectile = projectile.instance()
#	var targetPos = mech.targetting_cursor.global_position
#	newProjectile.init(mech, damage, damage_type, projectile_range, line_of_sight, targetPos)
#
#	if Global.current_scene != null:
##		if Global.current_scene.has_node("YSort/Projectiles"):
##			Global.current_scene.get_node("Ysort/Projectiles").add_child(newProjectile)
#		Global.current_scene.add_child(newProjectile)
#		newProjectile.global_position = $ShotgunSprite/MuzzleLocation.global_position
#		newProjectile.global_rotation = $ShotgunSprite.global_rotation

func make_noise(noiseStr:String):
	var noise
	
	# copy a ShootNoise.tscn node which will queue itself free after audio finished.
	if noiseStr == "shoot":
		noise = $ShootNoise.duplicate()
	elif noiseStr == "cock":
		noise = $CockNoise.duplicate()
	add_child(noise)
	
	noise.set_pitch_scale(rand_range(0.8, 1.2))
	noise.play()
	
	

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not disabled:
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
			
		$ShotgunSprite.look_at(targetPos + myPos)
		


func flash_muzzle():

	if has_node("AnimationPlayer"):
		if $AnimationPlayer.has_animation("flash"):
			$AnimationPlayer.play("flash")
		else:
			print("no flash animation")
	if Global.user_prefs["particles"]:
		$ShotgunSprite/MuzzleLocation/CPUParticles2D.emitting = false
		$ShotgunSprite/MuzzleLocation/CPUParticles2D.emitting = true




func _on_ReloadTimer_timeout():
	shots_left = shots_per_burst
	vary_reload_time()
	shoot()

func _on_CockDurationTimer_timeout():
	$AnimationPlayer.play("cock")
	make_noise("cock")








func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "cock":
		shoot()
