tool

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
export var packed_scene : PackedScene
export var instance_as_child: bool = false


func _ready():
	# connect signals
	
	#warning-ignore:RETURN_VALUE_DISCARDED
	connect("pressed", self, "_on_pressed")
	

func _get_configuration_warning() -> String:
	if packed_scene == null and (scene_path == null or scene_path == ""):
		return "Set one of the parameters: scene_path or packed_scene. packed_scene takes priority."
	else:
		return ""

func _on_pressed():
	
	if packed_scene == null:
		if ResourceLoader.exists(scene_path):
			packed_scene = load(scene_path)
		else:
			printerr("instance_scene_on_button.gd, problem in " + self.name + ". packed_scene or scene_path must be specified")
	if instance_as_child:
		owner.add_child(packed_scene.instance())
		owner.get_child(0).visible = false
	else:
		#warning-ignore:RETURN_VALUE_DISCARDED
		get_tree().change_scene_to(packed_scene)
