"""
A resource that represents any part that can be added to a mech.
A mech itself can be defined by a collection of parts (See the MechStructure class)
Referenced by BuildingPart in the mech builder, and by MechPart in the shmup.
"""
extends Resource
class_name Part

enum Type {
	HULL,
	MOBILITY,
	WEAPON,
	UTILITY
}

export var name : String
export(String, MULTILINE) var description : String
export var icon : Texture
export var mech_part : PackedScene
export(Type) var type
export var cost = 3

# Stats that the part contributes to the mech
export var health : int
export var power_draw : int
export var armor : int
export var shield : int
