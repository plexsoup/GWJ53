extends Label

var mech


func init(myMech):
	mech = myMech
	
func _ready():
	var timer = get_tree().create_timer(0.6)
	yield(timer, "timeout")
	text = "Team: " + str(mech.team)
	if mech.team > -1:
		set_modulate(Global.team_colors[mech.team])
