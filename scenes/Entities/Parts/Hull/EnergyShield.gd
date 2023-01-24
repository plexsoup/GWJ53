extends MechPart


export var shield_value : float = 500.0
export var regen_per_tick : float = 5.0
export var regen_tick_delay : float = 1.0
var rotation_speed : float = 2.0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func init(myMech):
	mech = myMech
	mech.shield_max += shield_value
	mech.shield += shield_value
	
	mech.shield_parts.append(self)

	draw_shield(Vector2.ZERO)
	$RegenTimer.set_wait_time(regen_tick_delay)
	$Line2D.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
	#$Sprite.rotate(rotation_speed*delta)
	#update()
	
func flash(impactVector):
	draw_shield(impactVector)
	$FlashTimer.start()
	
	
func draw_shield(impactVector):
	$Line2D.look_at(impactVector)
	
	$Line2D.visible = true
	
	var radius = 250.0
	var segments = 32.0
	var segmentRotation = TAU/segments

	var points = []
	for i in range(segments/2):
		points.push_back( (Vector2.RIGHT*radius).rotated(segmentRotation*i + PI/2) )
#		var teamColor = Global.team_colors[mech.team]
#		teamColor.a = 0.5
	$Line2D.points = points
	
	# Details moved to the inspector
	#var lineWidth = 15.0
	#var antiAliasing = true
	#var defaultColor = Color.aqua
	#defaultColor.a = max(min(mech.shield/shield_value, 1), 0)
	#$Line2D.width = lineWidth
	#$Line2D.antialiased = antiAliasing
	#$Line2D.default_color = teamColor
	#$Line2D.default_color = defaultColor
	#$Sprite.set_modulate(teamColor)


func _on_Timer_timeout():
	#if mech.shield <= 0:
	$Line2D.visible = false
	#$FlashTimer.stop()
		


func _on_RegenTimer_timeout():
	if mech.shield < shield_value:
		mech.shield += regen_per_tick
