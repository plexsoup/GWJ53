extends Node2D
class_name BuildingPart

var part : Part
var connected_parts := []

func _ready():
	$Sprite.texture = part.icon
