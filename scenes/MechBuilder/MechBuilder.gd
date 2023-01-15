extends Control

export(float) var min_joint_distance # Minimum distance parts should be seperated
export(float) var max_joint_distance # Maximum distance between connected parts

onready var part_buttons = $"%PartButtons"
onready var cursor : Sprite = $"%Cursor"
var selected_part : Part
var selected_part_button = null
var can_place_part = false

var strut_hints = []
var building_parts = []

func _ready():
	yield(Engine.get_main_loop(), "idle_frame")
	set_enabled_list_items()


func _on_part_button_pressed(part_button):
	selected_part = part_button.part
	selected_part_button = part_button
	cursor.texture = part_button.part.icon

func add_part_to_list(part : Part):
	var part_button = preload("res://scenes/MechBuilder/PartButton.tscn").instance()
	part_button.part = part
	part_buttons.add_child(part_button)
	part_button.connect("pressed", self, "_on_part_button_pressed", [part_button])


# Returns an array of BuildingParts that 
func get_nearby_parts(position : Vector2) -> Array:
	var nearby_parts = []
	for bp in building_parts:
		var dist = bp.global_position.distance_to(position)
		if dist <= max_joint_distance:
			nearby_parts.append(bp)
	return nearby_parts

func _process(delta):
	cursor.global_position = get_global_mouse_position()
	
	var nearby_parts = get_nearby_parts(cursor.global_position)
	var too_close = false
	for nearby_part in nearby_parts:
		if cursor.position.distance_to(nearby_part.position) < min_joint_distance:
			too_close = true
			break
	
	can_place_part = \
			selected_part != null and\
			not too_close and\
			nearby_parts.size() > 0 or\
			building_parts.size() == 0
	cursor.modulate = Color.greenyellow if can_place_part else Color.red
	
	for strut in strut_hints:
		strut.free()
	strut_hints.clear()
	
	if can_place_part:
		for nearby_part in nearby_parts:
			var strut = preload("res://scenes/MechBuilder/Strut.tscn").instance()
			$BuildingZone.add_child(strut)
			strut.length = cursor.position.distance_to(nearby_part.position)
			strut.position = cursor.position
			strut.look_at(nearby_part.position)
			$BuildingZone.move_child(strut, 0)
			strut_hints.append(strut)

func set_enabled_list_items():
	var any_hulls = false
#
	for building_part in building_parts:
		building_part = building_part as BuildingPart
		if building_part.part.type == Part.Type.HULL:
			any_hulls = true
	
	for part_button in part_buttons.get_children():
		var part = part_button.part
		if not any_hulls:
			part_button.disabled = part.type != Part.Type.HULL
		else:
			part_button.disabled = part.type == Part.Type.HULL
#	for i in parts_list.get_item_count():
#		var part = parts_list.get_item_metadata(i) as Part
#		if not any_hulls:
#			parts_list.set_item_disabled(i, part.type != Part.Type.HULL)
#		else:
#			parts_list.set_item_disabled(i, part.type == Part.Type.HULL)


func _unhandled_input(event):
	var clicked_w_mouse = false
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			clicked_w_mouse = true
	if event.is_action_pressed("place_part") or clicked_w_mouse:
		if not can_place_part:
			return
		
		# Add part
		var building_part = preload("res://scenes/MechBuilder/BuildingPart.tscn").instance()
		building_part.part = selected_part
		$BuildingZone.add_child(building_part)
		building_part.global_position = cursor.global_position
		building_parts.append(building_part)
		
		# Add struts
		for nearby_part in get_nearby_parts(building_part.global_position):
			var strut = preload("res://scenes/MechBuilder/Strut.tscn").instance()
			$BuildingZone.add_child(strut)
			strut.length = building_part.position.distance_to(nearby_part.position)
			strut.position = building_part.position
			strut.look_at(nearby_part.position)
			$BuildingZone.move_child(strut, 0)
		
		# Remove part from parts list
		
		selected_part_button.queue_free()
		selected_part = null
		cursor.texture = null
		set_enabled_list_items()

func generate_mech_structure() -> MechStructure:
	var mech_structure = MechStructure.new()
	
	var hull_building_part : BuildingPart
	for building_part in building_parts:
		building_part = building_part as BuildingPart
		if building_part.part.type == Part.Type.HULL:
			hull_building_part = building_part
			break
	
	for building_part in building_parts:
		building_part = building_part as BuildingPart
		var mech_structure_part = MechStructure.MechStructurePart.new()
		mech_structure_part.part = building_part.part
		mech_structure_part.position = building_part.position - hull_building_part.position
		mech_structure.inner_parts.append(mech_structure_part)
	
	return mech_structure
