extends Node


func _ready():
	# connect signals
	#warning-ignore:RETURN_VALUE_DISCARDED
	connect("pressed", self, "_on_pressed")


func _on_pressed():
	# quit if this is the root scene
	if owner.get_parent() == get_tree().root:
		get_tree().quit()
		return
		
	
	# grab focus of the parent scene
	owner.get_parent().grab_focus_of_node()
	# show parent scene panel again
	owner.get_parent().get_child(0).visible = true
	
	# delete current subscene
	owner.queue_free()
