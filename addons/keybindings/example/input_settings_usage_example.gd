extends Node

export(Resource) var settings
export(NodePath) var label_path
onready var label = get_node(label_path)

export(NodePath) var h_mouse_slider_path
onready var h_mouse_slider = get_node(h_mouse_slider_path)
export(NodePath) var v_mouse_slider_path
onready var v_mouse_slider = get_node(v_mouse_slider_path)

func _ready():
	if settings:
		h_mouse_slider.value = settings.mouse_horizontal_sensitivity
		v_mouse_slider.value = settings.mouse_vertical_sensitivity
		_update_visualization()


func _update_visualization():
	if settings:
		label.text = "Sensitivity: " + \
		str(settings.mouse_horizontal_sensitivity) + \
		" | " + \
		str(settings.mouse_vertical_sensitivity)


func _on_VMouseSensitivity_value_changed(value):
	if settings:
		settings.mouse_vertical_sensitivity = value
		_update_visualization()


func _on_HMouseSensitivity_value_changed(value):
	if settings:
		settings.mouse_horizontal_sensitivity = value
		_update_visualization()
