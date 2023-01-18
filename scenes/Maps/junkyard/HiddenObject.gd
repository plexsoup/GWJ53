tool
extends Area2D

export (Resource) var mech_part : Resource

signal found(partResource)


# Called when the node enters the scene tree for the first time.
func _ready():
	if Engine.editor_hint: # running in inspector
		pass # Replace with function body.

	
	if mech_part != null:
		$Sprite.texture = mech_part.icon
	

func _get_configuration_warning():
	if mech_part == null:
		return "add a mech_part resource as class Part"
	else:
		return ""
	


func _on_HiddenObject_mouse_entered():
	emit_signal("found", mech_part)
	
	$AnimationPlayer.play("pickup")
	


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "pickup":
		queue_free()
