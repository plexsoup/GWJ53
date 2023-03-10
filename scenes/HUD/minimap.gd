extends NinePatchRect

var map
var mech


# Called when the node enters the scene tree for the first time.
func _ready():
	map = Global.current_scene
	mech = Global.player
	
	$Center.position = get_size()/2


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func clear_minimap():
	for threatIcon in $Center/Threats.get_children():
		threatIcon.queue_free()

func update_minimap_icons():
	if mech == null:
		return
	
	var length = 32.0
	for enemy in get_tree().get_nodes_in_group("enemies"):
		var enemyDir = mech.global_position.direction_to(enemy.global_position)
		var enemyIcon = $ThreatIcon.duplicate()
		$Center/Threats.add_child(enemyIcon)
		enemyIcon.visible = true
		enemyIcon.position = enemyDir * length
	$Center/PlayerIcon.rotation = (Global.player_cursor.global_position - Global.player.global_position).angle() + PI/2
	

func _on_MapUpdateTimer_timeout():
	clear_minimap()
	update_minimap_icons()
