extends Node


enum Win_Requirements { TIME, KILL_COUNT, LAST_SURVIVOR }
var win_requirement = Win_Requirements.LAST_SURVIVOR

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func check_win_conditions():
	pass



func _on_WinCheckTimer_timeout():
	check_win_conditions()
	
