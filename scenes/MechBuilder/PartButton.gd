extends MarginContainer

signal pressed()

var part : Part
var disabled : bool setget _set_disabled

onready var texture_rect = $MarginContainer/VboxContainer/TextureRect
onready var label = $MarginContainer/VboxContainer/Label

func _ready():
	texture_rect.texture = part.icon
	label.text = part.name

func _set_disabled(v):
	disabled = v
	$Button.disabled = disabled


func _on_Button_pressed():
	emit_signal("pressed")
