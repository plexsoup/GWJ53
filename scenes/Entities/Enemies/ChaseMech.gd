extends KinematicBody2D


var current_path : PoolVector2Array = []
var level_navigation_map : RID
var target

# Called when the node enters the scene tree for the first time.
func _ready():
	level_navigation_map = get_world_2d().get_navigation_map()
	$NavUpdateTimer.start()

func init(myTarget):
	target = myTarget

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func update_nav():
	#$Line2D.points = [actor.global_position, get_global_mouse_position()]
	$Line2D.points = current_path
	var optimize = true
	var myPos = get_global_position()
	var targetPos = get_global_mouse_position()
	current_path = Navigation2DServer.map_get_path(level_navigation_map, myPos, targetPos, optimize)
	#nav_agent.set_target_location($Sprite.get_global_position())
	$NavUpdateTimer.start()

func _on_NavUpdateTimer_timeout():
	update_nav()
