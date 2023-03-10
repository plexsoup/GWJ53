# This is an autoload (singleton) which will save
# the key maps in a simple way through a dictionary.
extends Node

const keymaps_path = "user://keymaps.dat"
var keymaps: Dictionary


func _ready() -> void:
	# First we create the keymap dictionary on startup with all
	# the keymap actions we have.
	for action in InputMap.get_actions():
		if InputMap.get_action_list(action).size() > 0:
			keymaps[action] = InputMap.get_action_list(action)[0]
	load_keymap()


func load_keymap() -> void:
	var file := File.new()
	if not file.file_exists(keymaps_path):
		save_keymap() # There is no save file yet, so let's create one.
		return
	
	#warning-ignore:return_value_discarded
	file.open(keymaps_path, File.READ)
	var temp_keymap: Dictionary = file.get_var(true)
	file.close()
	
	# We don't just replace the keymaps dictionary, because if you
	# updated your game and removed/added keymaps, the data of this
	# save file may have invalid actions. So we check one by one to
	# make sure that the keymap dictionary really has all current actions.
	for action in keymaps.keys():
		if temp_keymap.has(action):
			keymaps[action] = temp_keymap[action]
			# Whilst setting the keymap dictionary, we also set the
			# correct InputMap event
			
			for existing_event in InputMap.get_action_list(action):
				if not existing_event is InputEventMouse:
					InputMap.action_erase_event(action, existing_event)
			InputMap.action_add_event(action, keymaps[action])


func save_keymap() -> void:
	# For saving the keymap, we just save the entire dictionary as a var.
	var file := File.new()
	#warning-ignore:return_value_discarded
	file.open(keymaps_path, File.WRITE)
	file.store_var(keymaps, true)
	file.close()
