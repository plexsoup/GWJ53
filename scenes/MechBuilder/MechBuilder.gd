extends Control

export(float) var min_joint_distance # Minimum distance parts should be seperated
export(float) var max_joint_distance # Maximum distance between connected parts
export(int) var reroll_cost = 1
export(PackedScene) var part_button_scene
export(PackedScene) var building_part_scene
export(PackedScene) var strut_scene

onready var part_buttons_hbox = $"%PartButtonsHBox"
var part_buttons = []
onready var money_label : Label = $"%MoneyLabel"
onready var cursor : Sprite = $"%Cursor"
var selected_part : Part
var selected_part_button = null
var can_place_part = false

var strut_hints = []
var building_parts = []

func _ready():
	var _discard
	if Global.persistent_mech == null:
		add_building_part(Global.parts_pool["L1Hull"])
		add_building_part(Global.parts_pool["Legs"], Vector2(0, 150))
		add_building_part(Global.parts_pool["BasicLaser"], Vector2(0, -150))
	else:
		for inner_part in Global.persistent_mech.inner_parts:
			inner_part = inner_part as MechStructure.MechStructurePart
			add_building_part(inner_part.part, inner_part.position)
	
	for part_name in Global.parts_pool:
			add_part_to_list(Global.parts_pool[part_name])
	_update_money_display()
	
func _update_money_display():
	money_label.text = "MONEY: %d" % Global.money


func _on_part_button_pressed(part_button):
	selected_part = part_button.part
	selected_part_button = part_button
	cursor.texture = part_button.part.icon

func add_part_to_list(part : Part):
	var part_button = part_button_scene.instance()
	part_button.part = part
	part_buttons_hbox.add_child(part_button)
	part_buttons.append(part_button)
	part_button.connect("pressed", self, "_on_part_button_pressed", [part_button])


# Returns an array of BuildingParts that 
func get_nearby_parts(position : Vector2) -> Array:
	var nearby_parts = []
	for bp in building_parts:
		var dist = bp.global_position.distance_to(position)
		if dist <= max_joint_distance:
			nearby_parts.append(bp)
	return nearby_parts

func _process(_delta):
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
			var strut = strut_scene.instance()
			strut.modulate = Color(1,1,1,0.2)
			$BuildingZone.add_child(strut)
			strut.length = cursor.position.distance_to(nearby_part.position)
			strut.position = cursor.position
			strut.look_at(nearby_part.position)
			$BuildingZone.move_child(strut, 0)
			strut_hints.append(strut)

func add_building_part(part : Part, position : Vector2 = Vector2.ZERO):
	# Add part
	var building_part = building_part_scene.instance()
	building_part.part = part
	$BuildingZone.add_child(building_part)
	building_part.global_position = position
	building_parts.append(building_part)
	
	# Add struts
	var tween = create_tween().set_parallel()
	for nearby_part in get_nearby_parts(building_part.global_position):
		var strut = strut_scene.instance()
		$BuildingZone.add_child(strut)
		tween.tween_property(strut, "length", building_part.position.distance_to(nearby_part.position), 0.2)
		strut.position = nearby_part.position
		strut.look_at(building_part.position)
		$BuildingZone.move_child(strut, 0)


func _unhandled_input(event):
	if event.is_action_pressed("place_part"):
		if not can_place_part:
			return
		if selected_part.cost > Global.money:
			$"%MoneyAnimation".stop()
			$"%MoneyAnimation".play("ShakeMoney")
			return
		Global.money -= selected_part.cost
		_update_money_display()
		add_building_part(selected_part, cursor.global_position)
		
		# Remove part from parts list
#		part_buttons.erase(selected_part_button)
#		var tween = create_tween()
#		tween.tween_property(selected_part_button, "rect_scale", selected_part_button.rect_scale * 2, 0.3)
#		tween.parallel().tween_property(selected_part_button, "modulate", Color(1,1,1,0), 0.3)
#		tween.tween_callback(selected_part_button, "queue_free")

		selected_part_button = null
		selected_part = null
		cursor.texture = null
		
	if event.is_action_pressed("ui_cancel"):
		if selected_part_button :selected_part_button.release_focus()
		selected_part_button = null
		selected_part = null
		cursor.texture = null

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


func _on_FightButton_pressed():
	var mech_structure = generate_mech_structure()
	var player = mech_structure.create_entity(preload("res://scenes/Entities/Player/Player.tscn"))
	Global.player = player
	Global.persistent_mech = mech_structure
	Global.stage_manager.start_next_battle(player)
