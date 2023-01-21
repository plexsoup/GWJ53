extends Control


export var next_scene: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready():
	var dialog =Dialogic.start("Victory Screen")
	
	add_child(dialog) 
	dialog.connect("timeline_end", self, "_on_dialog_ended")

	dialog.connect("dialogic_signal", self, "_on_dialog_ended")

	
func _on_dialog_ended(_signal_properties):
	if next_scene != null:
		Global.stage_manager.change_scene_to(next_scene)
	else:
		Global.state_manager.change_scene("res://scenes/Menus/MainMenu02.tscn")

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		_on_dialog_ended("play_hit_escape")
		
	
