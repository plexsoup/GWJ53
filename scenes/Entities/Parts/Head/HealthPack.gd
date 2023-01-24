extends MechPart


export var healing : float = 50.0
export var healing_interval : float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.set_wait_time(healing_interval)
	$Timer.start()


func init(myMech):
	mech = myMech


func _on_Timer_timeout():
	heal_mech()
	
func heal_mech():
	if mech.health < mech.health_max:
		mech.health = min(mech.health + healing, mech.health_max)
		if Global.user_prefs["particles"]:
			$CPUParticles2D.emitting = true
		mech.update_health_bar()
