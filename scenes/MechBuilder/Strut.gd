extends Node2D
tool

export var length : float setget _set_length

func _set_length(v):
	if not is_inside_tree():
		yield(self, "ready")
	length = v
	$NinePatchRect.rect_size.x = length
