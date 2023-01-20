extends MarginContainer

signal pressed()

var part : Part
var disabled : bool setget _set_disabled


onready var icon = $"%Icon"
onready var name_label = $"%Name"
onready var cost_label = $"%CostLabel"

func _ready():
	cost_label.text = str(part.cost)
	icon.texture = part.icon
	name_label.text = part.name
	$Button.connect("mouse_entered", self, "emit_signal", ["mouse_entered"])
	$Button.connect("mouse_exited", self, "emit_signal", ["mouse_exited"])
	

func _set_disabled(v):
	disabled = v
	$Button.disabled = disabled


func _on_Button_pressed():
	emit_signal("pressed")
