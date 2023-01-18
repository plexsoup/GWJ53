extends Node


var player
var current_scene
var stage_manager
var game_speed : float = 1.0 # Slow Motion < 1.0, Speed Up > 1.0
var auto_targetting: bool = false # false = binding twin-stick roguelite, true = bullet_heaven vampire survivors clone
var player_cursor : Sprite # in battles, always use this for targetting instead of get_global_mouse_position()

enum damage_types { IMPACT, LASER, FIRE, SHOCK }

var battles = ["Desert Canyon", "Junkyard", "Old Port"]
var battle_scenes = {
	"Street Battle" : "res://scenes/Maps/StreetBattle01.tscn",
	"Old Port":"res://scenes/Maps/StreetBattle01.tscn",
	"Desert Canyon":"res://scenes/Maps/DesertCanyonBattle.tscn",
	"Junkyard": "res://scenes/Maps/StreetBattle01.tscn",
}
var battles_completed = []
var team_colors = [Color.red, Color.blue, Color.yellow, Color.purple, Color.peru]

var parts_pool := {}
func _ready():
	# populate the parts pool
	var dir = Directory.new()
	var folders = ["res://scenes/Entities/Parts"]
	var i = 0
	while i < folders.size():
		var folder = folders[i]
		dir.open(folder)
		dir.list_dir_begin(true)
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				folders.append("/".join([folder, file_name]))
			else:
				if file_name.get_extension() == "tres":
					parts_pool[file_name.get_basename()] = load("/".join([folder, file_name]))
			file_name = dir.get_next()
		i += 1
