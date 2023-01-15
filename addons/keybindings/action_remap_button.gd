extends Button

export(String) var action = "ui_up"

func _ready():
	assert(InputMap.has_action(action))
	set_process_unhandled_key_input(false)
	display_current_key()


func _toggled(button_pressed):
	set_process_unhandled_key_input(button_pressed)
	if button_pressed:
		text = "... Key"
		release_focus()
	else:
		display_current_key()


func _unhandled_key_input(event):
	# Note that you can use the _input callback instead, especially if
	# you want to work with gamepads.
	
	# stop key change, when cancel action was pressed
	if not event.is_action("ui_cancel"):
		remap_action_to(event)
	pressed = false


func remap_action_to(event):
	# We first change the event in this game instance.
	for existing_event in InputMap.get_action_list(action):
		if not existing_event is InputEventMouse:
			InputMap.action_erase_event(action, existing_event)
	InputMap.action_add_event(action, event)
	# And then save it to the keymaps file
	KeyPersistence.keymaps[action] = event
	KeyPersistence.save_keymap()


func display_current_key():
	var current_key
	if InputMap.get_action_list(action).size() > 0:
		current_key = InputMap.get_action_list(action)[-1].as_text()
		text = current_key + " Key"
	else:
		current_key = "No"
		text = "unbound"
