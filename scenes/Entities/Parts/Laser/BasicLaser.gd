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

enum States { RELOADING, SHOOTING }
var State = States.RELOADING

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	$ReloadTimer.start()

func init(myMech):
	mech = myMech
	
func shoot():
	# WIP we should ask the target acquisition system for a target
	if mech != null and mech.State == mech.States.READY:
		State = States.SHOOTING
		$Line2D.default_color = Color(1,1,0,0.66)
		$ShotDurationTimer.start()
		
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	aim_laser(delta)
	

func aim_laser(_delta):
	if Global.player_cursor != null:
		var myPos = self.global_position
		var cursorPos = Global.player_cursor.get_global_position() # note, cursor might be on autopilot depending on Global.auto_targetting
		var targetPos = cursorPos
		if myPos.distance_squared_to(cursorPos) > beam_range * beam_range:
			targetPos = myPos.direction_to(cursorPos)*beam_range
		else:
			targetPos = cursorPos - myPos
			
		$LaserCannon.look_at(targetPos + myPos)
		if State == States.SHOOTING:
			var rescaled_target_pos = Vector2(targetPos.x / global_scale.x, targetPos.y / global_scale.y)
			$Line2D.points = [ Vector2.ZERO, rescaled_target_pos]
			$TargetLocation.position = rescaled_target_pos
			$TargetLocation/CPUParticles2D.emitting = true
		else:
			$TargetLocation/CPUParticles2D.emitting = false


func _on_ReloadTimer_timeout():
	shoot()



func _on_ShotDurationTimer_timeout():
	$Line2D.default_color = Color(0,0,0,0)
	State = States.RELOADING
	$ReloadTimer.start()
