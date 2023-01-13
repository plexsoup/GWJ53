extends Node


export(NodePath) var ui_element_path
onready var ui_element = get_node(ui_element_path)


# Called when the node enters the scene tree for the first time.
func _ready():
	grab_focus_of_node()

func grab_focus_of_node():
	ui_element.grab_focus()
