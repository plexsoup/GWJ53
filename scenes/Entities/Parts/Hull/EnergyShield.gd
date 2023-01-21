extends Node2D


var mech
export var shield_value : float = 500.0

var rotation_speed : float = 2.0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func init(myMech):
	mech = myMech
	mech.shield_max += shield_value
	mech.shield += shield_value
	
	#draw_shield()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Sprite.rotate(rotation_speed*delta)
	#update()
	
	
func draw_shield():
	pass
	
#	if mech.shield > 0:
#		var radius = 500.0
#		var segments = 12.0
#		var segmentRotation = TAU/segments
#		var lineWidth = 15.0
#		var antiAliasing = true
#		var points = []
#		for i in range(segments+1):
#			points.push_back( (Vector2.RIGHT*radius).rotated(segmentRotation*i) )
#		var teamColor = Global.team_colors[mech.team]
#		teamColor.a = 0.5
#		$Line2D.points = points
#		$Line2D.width = lineWidth
#		$Line2D.antialiased = antiAliasing
#		$Line2D.default_color = teamColor
#		$Sprite.set_modulate(teamColor)


func _on_Timer_timeout():
	if mech.shield <= 0:
		$Line2D.visible = false
		$Timer.stop()
		
