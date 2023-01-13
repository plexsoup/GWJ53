# Keybinding Plugin
The code in this plugin is mostly copied from: https://github.com/godotengine/godot-demo-projects/tree/master/gui/input_mapping.

The keymap will be saved to the user directory.
```
Win: %APPDATA%/<Project Name>
Linus, macOS: ~/.local/share/godot/app_userdata/<Project Name>
```

## Change Keybindings
### Setup
- implement your own keybinding menu (addons/keybinding_menu can be used as a reference)
	- the translation file (addons/keybindings/localisation/keybind_menu_strings.en.translation) for the example menu has to be added manually to work (Project Settings > Translations)

### Note:
- the Directory of the keymap might not be the project name, if a custom user dir was set
	- Advanced Settings must be enabled to view "Use Custom User Dir"
	- Project Settings > General > Application > Config > Use Custom User Dir
- right now this plugin only cares about the primary binding and ignores the rest
- potentially it might remove additional bindings
	- has to be checked


## Change Sensitivity
The horizontal and vertical mouse sensitivity gets saved in a custom resource (resources/input_settings_data). Additional settings can be added by customizing resources/input_settings.gd.

The sensitivity settings can be used by implementing an export variable. An example of the usage is given in Examples/input_settings_usage_example.gd.

The sensitivity can be used similar to the example from the [Godot FPS tutorial](https://docs.godotengine.org/en/3.3/tutorials/3d/fps_tutorial/part_one.html). MOUSE_SENSITIVITY would be settings.mouse_horizontal_sensitivity in the implementation in this project.
```
func _input(event):
    if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
        rotation_helper.rotate_x(deg2rad(event.relative.y * MOUSE_SENSITIVITY))
        self.rotate_y(deg2rad(event.relative.x * MOUSE_SENSITIVITY * -1))

        var camera_rot = rotation_helper.rotation_degrees
        camera_rot.x = clamp(camera_rot.x, -70, 70)
        rotation_helper.rotation_degrees = camera_rot
```