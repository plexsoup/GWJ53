# UI Navigation via Keyboard Tutorial
Godot makes it easy to navigate the UI if you know how.
All you have to do is include a small code snippet, to select the UI element that will be focused by default.

This can be done with a small script on the object:
```
func _ready():
    grab_focus()
```

or from a different entry point:
```
export(NodePath) var ui_element_path
onready var ui_element = get_node(ui_element_path)

func _ready():
    ui_element.grab_focus()
```

For both solutions there are examples included inside of this addon.
- self_grab_focus.gd
- other_grab_focus.gd