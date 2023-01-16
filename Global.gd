extends Node


var player
var current_scene
var stage_manager
var game_speed : float = 1.0 # Slow Motion < 1.0, Speed Up > 1.0
var auto_targetting: bool = false # false = binding twin-stick roguelite, true = bullet_heaven vampire survivors clone
var player_cursor : Sprite # in battles, always use this for targetting instead of get_global_mouse_position()

enum damage_types { IMPACT, LASER, FIRE, SHOCK }
