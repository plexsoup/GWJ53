tool
extends Area2D

export (Resource) var mech_part : Resource

var found : bool = false

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
	if !found:
		found = true
		var tween = create_tween()
		tween.set_parallel().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
		tween.tween_property($Sprite, "global_position", $Sprite.global_position + Vector2(0, -100), 0.5)
		tween.tween_property($Sprite, "rotation_degrees", $Sprite.rotation_degrees + rand_range(-50, 50), 0.5)
		tween.tween_property($Sprite, "modulate", Color(1,1,1,0), 0.5)
		if Global.user_prefs["particles"]:
			$CPUParticles2D.emitting = true
		$AudioStreamPlayer2D.play()
		yield(tween, "finished")
		emit_signal("found", mech_part)
		queue_free()
