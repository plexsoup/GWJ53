extends Control

var parts_found = [] # list of Part resource RIDs
var num_parts_to_find = 3
export var next_scene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	for part in $SecretParts.get_children():
		
		part.position.x = rand_range(0, 1024)
		part.position.y = rand_range(0, 600)

		part.connect("found", self, "_on_part_found")

func found_all_parts():
	# TODO: Pass the cards back to the mechbuilder hangar or player deck
	Global.stage_manager.change_scene_to(next_scene)
	

func _on_part_found(partResource : Part):
	parts_found.push_back(partResource)
	if parts_found.size() >= num_parts_to_find:
		found_all_parts()
	