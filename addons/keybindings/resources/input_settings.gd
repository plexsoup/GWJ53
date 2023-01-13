extends Resource
class_name Input_Settings


export(float) var mouse_horizontal_sensitivity
export(float) var mouse_vertical_sensitivity


# Make sure that every parameter has a default value.
# Otherwise, there will be problems with creating and editing
# your resource via the inspector.
func _init(p_mouse_horizontal_sensitivity = 1.0, p_mouse_vertical_sensitivity = 1.0):
    mouse_horizontal_sensitivity = p_mouse_horizontal_sensitivity
    mouse_vertical_sensitivity = p_mouse_vertical_sensitivity
