extends Node2D
class_name BuildingPart

signal mouse_entered()
signal mouse_exited()
signal fling()

var part : Part
var connected_parts := []

var _vel = Vector2()
var _spin = 0
var _flying = false

func _ready():
	if Global.user_prefs["particles"]:
		$AnimationPlayer.play("Build")
	$Sprite.texture = part.icon
	if part.type == Part.Type.HULL:
		$Area2D.input_pickable = false

func _process(delta):
	if _flying:
		_vel.y += 981 * delta
		position += _vel * delta
		rotation += _spin * delta


func _on_Area2D_mouse_entered():
	emit_signal("mouse_entered")


func _on_Area2D_mouse_exited():
	emit_signal("mouse_exited")

func fling():
	emit_signal("fling")
	_flying = true
	_vel = Vector2(rand_range(-100, 100), rand_range(0, -300)) * 3
	_spin = rand_range(-10, 10)
	var tween = create_tween()
	tween.tween_interval(2)
	tween.tween_property(self, "scale", Vector2.ZERO, 1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween.tween_callback(self, "queue_free")
