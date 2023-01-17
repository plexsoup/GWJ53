extends KinematicBody2D


var max_health = 100.0
var health = max_health
var speed = 200.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(_delta):
	var velocity = Vector2.ZERO
	velocity += $PathfindToPlayer.get_next_point().normalized() * speed
	#warning-ignore:RETURN_VALUE_DISCARDED
	move_and_slide( velocity )


func die():
	$DeathTimer.start()

func die_for_real_this_time():
	$DecayTimer.start()

func knockback(_impulseVector):
	pass

func _on_hit(damage, impulseVector, _damageAttributes):
	health -= damage
	knockback(impulseVector)
	if damage <= 0:
		die()
		


func _on_DeathTimer_timeout():
	die_for_real_this_time()
