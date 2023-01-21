extends Control

onready var tool_tip_area = $"%ToolTipArea"
onready var tool_tip_boundaries = Rect2(tool_tip_area.rect_position, tool_tip_area.rect_size)
onready var part_buttons_h_box = $"%PartButtonsHBox"
onready var tool_tip_text = $"%ToolTipText"
onready var builder = get_parent()

var hovered_part_button = null

func _ready():
	hide()
	yield(part_buttons_h_box, "sort_children")
	for part_button in part_buttons_h_box.get_children():
		part_button.connect("mouse_entered", self, "_on_part_button_mouse_entered", [part_button])
		part_button.connect("mouse_exited", self, "_on_part_button_mouse_exited", [part_button])
	print(part_buttons_h_box.get_child_count())
	print(tool_tip_boundaries)

func _process(delta):
	var panel_size = $PanelContainer.rect_size
	rect_position.x = clamp(get_global_mouse_position().x, 
		tool_tip_boundaries.position.x + panel_size.x/2,
		tool_tip_boundaries.end.x - panel_size.x/2)
	
	rect_position.y = clamp(get_global_mouse_position().y, 
		tool_tip_boundaries.position.y + panel_size.y,
		tool_tip_boundaries.end.y)

func _on_part_button_mouse_entered(part_button):
	print("oi")
	hovered_part_button = part_button
	tool_tip_text.bbcode_text = "[center]%s[/center]" % part_button.part.description
	show()

func _on_part_button_mouse_exited(part_button):
	if hovered_part_button == part_button:
		hovered_part_button = null
		hide()
