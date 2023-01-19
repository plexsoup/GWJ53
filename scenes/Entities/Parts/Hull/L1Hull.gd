extends Node2D

var mech


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func init(myMech):
	mech = myMech


func _on_stopped_walking(_velocity):
	$AnimationPlayer.play("idle")

func _on_started_walking(_velocity):
	$AnimationPlayer.play("walk")

func _on_mech_died():
	$AnimationPlayer.stop()
