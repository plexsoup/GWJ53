extends Control


export var next_scene: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready():
	var dialog =Dialogic.start("Intro")
	
	add_child(dialog) 
	dialog.connect("timeline_end", self, "_on_dialog_ended")

	dialog.connect("dialogic_signal", self, "_on_dialog_ended")

	
func _on_dialog_ended(signal_properties):
	if signal_properties == "show skip":
		var tween = create_tween()
		tween.tween_property($MarginContainer/EscToSkipLabel, "modulate", Color.white, 5)
		return
	
	Global.into_has_played = true
	Global.stage_manager.change_scene_to(next_scene)

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		_on_dialog_ended("play_hit_escape")
		
	
