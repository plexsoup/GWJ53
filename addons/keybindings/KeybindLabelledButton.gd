tool
extends HBoxContainer


export var button_name : String setget set_button_name
export var action_name : String setget set_action_name




# Called when the node enters the scene tree for the first time.
func _ready():
	if Engine.editor_hint: # running in inspector
		if action_name != null and action_name != "":
			$Button.action = action_name

func set_button_name(buttonName):
	$Label.text = buttonName
	button_name = buttonName
	
func set_action_name(actionName):
	$Button.action = actionName
	action_name = actionName
	

	
