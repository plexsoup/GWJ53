extends Node


export(NodePath) var ui_element_path
onready var ui_element


# Called when the node enters the scene tree for the first time.
func _ready():
	if ui_element_path != null:
		ui_element = get_node(ui_element_path)
		grab_focus_of_node()
	else:
		printerr(self.name + " needs a nodePath for ui_element in other_grab_focus.gd. " + get_node("../..").name + " / " + get_parent().name)
		ui_element = get_parent()
		grab_focus_of_node()

func grab_focus_of_node():
	if ui_element != null:
		ui_element.grab_focus()
	else:
		printerr("other_grab_focus.gd in " + self.name + " needs a ui_element nodepath property set to auto-assign focus.")
