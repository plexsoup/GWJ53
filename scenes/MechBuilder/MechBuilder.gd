extends Control

export(float) var min_joint_distance
export(float) var max_joint_distance 

onready var parts_list : ItemList = $"%PartsList"
onready var cursor : Sprite = $"%Cursor"
var selected_part : Part
var can_place_part = false

var building_parts = []

func _on_PartsList_item_selected(index):
	selected_part = parts_list.get_item_metadata(index)
	cursor.texture = selected_part.icon

func add_part_to_list(part : Part):
	parts_list.add_item(part.name, part.icon)
	var part_index = parts_list.get_item_count()-1
	parts_list.set_item_metadata(part_index, part)
	parts_list.set_item_tooltip(part_index, part.description)

func get_nearby_parts(position : Vector2) -> Array:
	var nearby_parts = []
	for bp in building_parts:
		var dist = bp.global_position.distance_to(position)
		if dist <= max_joint_distance and dist >= min_joint_distance:
			nearby_parts.append(bp)
	return nearby_parts

func _process(delta):
	cursor.global_position = get_global_mouse_position()
	
	can_place_part = \
			selected_part != null and\
			get_nearby_parts(cursor.global_position).size() > 0 or\
			building_parts.size() == 0
	cursor.modulate = Color.greenyellow if can_place_part else Color.red

func _unhandled_input(event):
	if event.is_action_pressed("place_part"):
		if not can_place_part:
			return
		
		var building_part = preload("res://scenes/MechBuilder/BuildingPart.tscn").instance()
		building_part.part = selected_part
		$BuildingZone.add_child(building_part)
		building_part.global_position = cursor.global_position
		building_parts.append(building_part)
		
		parts_list.remove_item(parts_list.get_selected_items()[0])
		parts_list.unselect_all()
		selected_part = null
		cursor.texture = null
