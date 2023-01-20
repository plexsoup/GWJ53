extends Control


var current_position : int = 0
var banner_width : int = 250


# Called when the node enters the scene tree for the first time.
func _ready():
	var delay = get_tree().create_timer(0.75)
	yield(delay, "timeout")
	var teams_in_game = Global.current_scene.get_spawner_teams_list()
	teams_in_game.push_back(Global.player.team)
	for team in teams_in_game:
		slide_in(team)

func hide_character_portrait():
	for character in find_node("Characters").get_children():
		character.visible = false
	
func slide_in(team):
	var _colorStrs = Global.team_names
	
	for character in find_node("Characters").get_children():
		if character.get_position_in_parent() == team:
			character.visible = true
			character.margin_left = current_position * banner_width
	current_position += 1
		
		
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_HyperDurationTimer_timeout():
	# should fade out or something, but this'll do for now
	queue_free()
