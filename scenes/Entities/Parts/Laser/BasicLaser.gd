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
export var projectile : PackedScene

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
func _process(_delta):
	if Global.player_cursor != null:
		var mousePos = Global.player_cursor.get_global_position() # note, cursor might be on autopilot depending on Global.auto_targetting
		$LaserCannon.look_at(mousePos)
		if State == States.SHOOTING:
			$Line2D.points = [ Vector2.ZERO, mousePos - global_position]
		


func _on_ReloadTimer_timeout():
	shoot()



func _on_ShotDurationTimer_timeout():
	$Line2D.default_color = Color(0,0,0,0)
	State = States.RELOADING
	$ReloadTimer.start()
