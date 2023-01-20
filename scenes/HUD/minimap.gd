extends NinePatchRect

var map
var mech


# Called when the node enters the scene tree for the first time.
func _ready():
	map = Global.current_scene
	mech = Global.player
	
	$PlayerIcon.position = get_size()/2


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func clear_minimap():
	for threatIcon in $PlayerIcon.get_children():
		threatIcon.queue_free()

func update_minimap_icons():

	var length = 32.0
	for enemy in get_tree().get_nodes_in_group("enemies"):
		var enemyDir = mech.global_position.direction_to(enemy.global_position)
		var enemyIcon = $ThreatIcon.duplicate()
		$PlayerIcon.add_child(enemyIcon)
		enemyIcon.visible = true
		enemyIcon.position = enemyDir * length
	

func _on_MapUpdateTimer_timeout():
	clear_minimap()
	update_minimap_icons()
