extends Control

var parts_found = [] # list of Part resource RIDs
var num_parts_to_find = 3
export var next_scene : PackedScene
export var hidden_object_scene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	for inner_part in Global.persistent_mech.inner_parts:
		var hidden_object = hidden_object_scene.instance()
		hidden_object.mech_part = inner_part.part
		$SecretParts.add_child(hidden_object)
		num_parts_to_find += 1
	
	for part in $SecretParts.get_children():
		
		var rect = $ReferenceRect.get_rect()
		
		part.position.x = rand_range(rect.position.x, rect.end.x)
		part.position.y = rand_range(rect.position.y, rect.end.y)

		part.connect("found", self, "_on_part_found")

func found_all_parts():
	# TODO: Pass the cards back to the mechbuilder hangar or player deck
	Global.stage_manager.change_scene_to(next_scene)
	

func _on_part_found(partResource : Part):
	parts_found.push_back(partResource)
	if parts_found.size() >= num_parts_to_find:
		found_all_parts()
	
