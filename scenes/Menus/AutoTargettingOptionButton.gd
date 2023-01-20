extends CheckButton



# Called when the node enters the scene tree for the first time.
func _ready():
	pressed = Global.auto_targetting





func _on_AutoTargettingOptionButton_toggled(button_pressed):
	Global.auto_targetting = button_pressed
