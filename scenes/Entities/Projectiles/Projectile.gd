"""
Basic projectile

spawned, then travels until it reaches target position or range

It seems like inherited animation players can't have custom animations for children,
so you can create a new AnimationPlayer with a custom explode animation to override the default.

"""

extends Area2D

var mech : KinematicBody2D # whoever launched you
var damage : float
var damage_type : int # see Global.damage_types
var projectile_range : float
var line_of_sight : bool
var target_location : Vector2
var speed : float = 600.0
var velocity : Vector2

enum States { FLYING, EXPLODING, DEAD }
var State = States.FLYING

signal hit



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func init(myMech, myDamage, damageType, projectileRange, lineOfSight, targetLocation):
	mech = myMech
	damage = myDamage
	damage_type = damageType
	projectile_range = projectileRange
	line_of_sight = lineOfSight
	target_location = targetLocation
	
	if mech.is_in_group("enemies"):
		set_collision_layer_bit(3, true)
	elif mech.is_human_player:
		set_collision_layer_bit(2, true)
	set_collision_mask_bit(0, true)
	set_collision_mask_bit(1, true)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if State == States.FLYING:
		velocity = Vector2.RIGHT.rotated(global_rotation) * speed
		global_position += velocity * delta


func explode():
	$CollisionShape2D.set_scale($CollisionShape2D.get_scale()*3.0)
	var possibleTargets = get_overlapping_bodies()
	for body in possibleTargets:
		hurt(body)
		if has_node("AnimationPlayer") and get_node("AnimationPlayer").has_animation("explode"): # custom AnimationPlayer on scenes that inherit this scene.
			$AnimationPlayer.play("explode")
		else:
			$defaultAnimationPlayer.play("explode")
			
	State = States.EXPLODING

func hurt(body):
	if body.has_method("_on_hit"):
		#warning-ignore:RETURN_VALUE_DISCARDED
		connect("hit", body, "_on_hit")
		var impactVector = body.global_position - self.global_position
		emit_signal("hit", damage, impactVector, damage_type)
		disconnect("hit", body, "_on_hit")
	

func _on_Projectile_body_entered(body):
	if State == States.FLYING and line_of_sight:
		if body.has_method("_on_hit") and body.team != mech.team:
			explode()
	elif State == States.EXPLODING:
		if body.get("team") != mech.team:
			hurt(body)
			
			


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "explode":
		call_deferred("queue_free")
		
