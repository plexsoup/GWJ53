# To note:
# Right now the code expects that a scene is structered in the following way:
#   Root
#   |-> Panel
#       |-> other nodes
# When another scene is loaded, the panel will be hidden, to not disturb the
# keyboard controlls of the UI elements. If the scenes are structured in a
# different way, this code and return_from_instanced_scene.gd have to be adjusted.
#
# This structure is also expected by the return_from_instanced_scene.gd script.


extends Node


export(String, FILE, "*tscn") var scene_path
export var instance_as_child: bool = false


func _ready():
	# connect signals
	
	#warning-ignore:RETURN_VALUE_DISCARDED
	connect("pressed", self, "_on_pressed")
	
	# TODO: assert scene exists
	assert(ResourceLoader.exists(scene_path), "No scene exists at: " + scene_path + "!" +
	"\nObject: " + self.name + 
	"\nScene: " + owner.get_name())


func _on_pressed():
	if instance_as_child:
		var scene = load(scene_path).instance()
		owner.add_child(scene)
		owner.get_child(0).visible = false
	else:
		#warning-ignore:RETURN_VALUE_DISCARDED
		get_tree().change_scene(scene_path)
