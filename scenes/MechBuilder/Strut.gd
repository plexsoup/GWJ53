extends Node2D
tool

export var length : float setget _set_length

var anchor_1 : Node2D
var anchor_2 : Node2D

func _set_length(v):
	if not is_inside_tree():
		yield(self, "ready")
	length = v
	$NinePatchRect.rect_size.x = length

func _process(delta):
	if anchor_1 and anchor_2:
		global_position = anchor_1.global_position
		look_at(anchor_2.global_position)
		_set_length(anchor_1.global_position.distance_to(anchor_2.global_position))
