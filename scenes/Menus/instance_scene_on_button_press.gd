

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

tool
extends BaseButton


export(String, FILE, "*tscn") var scene_path
export var packed_scene : PackedScene
export var instance_as_child: bool = false
export var quit_game : bool = false
export var return_to_previous_screen : bool = false


func _ready():
	# connect signals
	
	#warning-ignore:RETURN_VALUE_DISCARDED
	connect("pressed", self, "_on_pressed")
	#warning-ignore:RETURN_VALUE_DISCARDED
	connect("focus_entered", self, "_on_hover")
	#warning-ignore:RETURN_VALUE_DISCARDED
	connect("focus_exited", self, "_on_stop_hovering")
	#warning-ignore:RETURN_VALUE_DISCARDED
	connect("mouse_entered", self, "_on_hover")
	#warning-ignore:RETURN_VALUE_DISCARDED
	connect("mouse_exited", self, "_on_stop_hovering")



func _get_configuration_warning() -> String:
	if packed_scene == null and (scene_path == null or scene_path == ""):
		return "Set one of the parameters: scene_path or packed_scene. packed_scene takes priority."
	else:
		return ""

func _on_pressed():
	get_tree().paused = false
	
	if quit_game:
		#if owner.get_parent() == get_tree().root:
		get_tree().quit()
	elif return_to_previous_screen:
		print("owner: " + owner.name)
		owner.queue_free()
	
	
	if has_node("ClickNoise"):
		get_node("ClickNoise").play()
	
	if packed_scene == null:
		if ResourceLoader.exists(scene_path):
			packed_scene = load(scene_path)
		else:
			printerr("instance_scene_on_button.gd, problem in " + self.name + ". packed_scene or scene_path must be specified")
	
	Global.stage_manager.change_scene_to(packed_scene)

#	if instance_as_child:
#		owner.add_child(packed_scene.instance())
#		owner.get_child(0).visible = false
#	else:
#		#warning-ignore:RETURN_VALUE_DISCARDED
#		get_tree().change_scene_to(packed_scene)


func _on_hover():
	if has_node("HoverNoise") and disabled == false:
		get_node("HoverNoise").play()

		var outline_font = ResourceLoader.load("res://_common/Fonts/RobotoBoldItalicPurpleOutline.tres")
		#add_font_override("purple_outline", outline_font)
		set("custom_fonts/font", outline_font)

func _on_stop_hovering():
	set("custom_fonts/font", null)
