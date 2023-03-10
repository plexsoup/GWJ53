extends Camera2D

export var default_zoom = 5.0
export var max_zoom = 24.0
export var min_zoom = 1.0
var current_zoom = max_zoom * 2.0

var zoom_speed := 1.1
var target_zoom : float

export var look_ahead : bool = false
var look_ahead_factor = 0.0
export var damping : float = 30.0

var player

# Called when the node enters the scene tree for the first time.
func _ready():
#	set_zoom(Vector2.ONE * current_zoom)
	target_zoom = current_zoom
	player = get_parent()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player.State != player.States.DYING:
		if look_ahead:
			camera_look_ahead(delta)
	zoom = zoom.linear_interpolate(Vector2.ONE * target_zoom, delta * 5)
	

func _unhandled_input(event):
	if target_zoom > max_zoom:
		return
	if event.is_action("camera_zoom_in") and Input.is_action_just_pressed("camera_zoom_in"):
		
		if get_zoom().x > min_zoom:
			target_zoom /= zoom_speed

	elif event.is_action("camera_zoom_out") and Input.is_action_just_pressed("camera_zoom_out"):
		if get_zoom().x < max_zoom:
			target_zoom *= zoom_speed
			
	target_zoom = clamp(target_zoom, min_zoom, max_zoom)

func camera_look_ahead(delta):
	var mousePos = get_global_mouse_position()
	var currentPos = get_parent().global_position
	var averagePos = lerp(currentPos, mousePos, look_ahead_factor)
	var newPos = lerp(global_position, averagePos, damping * delta)
	set_global_position(newPos)
	
func zoom_into_battle():
	# change this to lerp.
	var tween = get_tree().create_tween()
	tween.tween_property(self, "target_zoom", default_zoom, 1.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property(self, "look_ahead_factor", 0.4, 1.0)
	
	
