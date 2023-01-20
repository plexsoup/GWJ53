extends Control


export var next_scene: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready():
	var dialog =Dialogic.start("Intro")
	
	add_child(dialog) 
	dialog.connect("timeline_end", self, "_on_dialog_ended")

	dialog.connect("dialogic_signal", self, "_on_dialog_ended")

	
func _on_dialog_ended(_signal_properties):
	Global.stage_manager.change_scene_to(next_scene)

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		_on_dialog_ended("play_hit_escape")
		
	
