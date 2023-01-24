extends Node2D


export var next_scene : PackedScene


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _unhandled_input(_event):
	if Input.is_action_just_pressed("ui_cancel"):
		start_battle()

func start_battle():
	Global.stage_manager.change_scene_to(next_scene)


func _on_VideoPlayer_finished():
	start_battle()
