extends Camera2D

export var default_zoom = 3.0
export var max_zoom = 6.0
export var min_zoom = 1.0
var current_zoom = max_zoom * 2.0

export var look_ahead : bool = false
export var damping : float = 30.0

var player

# Called when the node enters the scene tree for the first time.
func _ready():
	set_zoom(Vector2.ONE * current_zoom)
	player = get_parent()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player.State != player.States.DEAD:
		if look_ahead:
			look_ahead(delta)

func _unhandled_input(event):
	if event.is_action("camera_zoom_in") and Input.is_action_just_pressed("camera_zoom_in"):
		
		if get_zoom().x > min_zoom:
			set_zoom( get_zoom() - Vector2(0.1, 0.1) )

	elif event.is_action("camera_zoom_out") and Input.is_action_just_pressed("camera_zoom_out"):
		if get_zoom().x < max_zoom:
			set_zoom( get_zoom() + Vector2(0.1, 0.1))

func look_ahead(delta):
	var mousePos = get_global_mouse_position()
	var currentPos = get_parent().global_position
	var averagePos = (mousePos + currentPos) / 2
	var newPos = lerp(currentPos, averagePos, damping * delta)
	set_global_position(newPos)
	
func zoom_into_battle():
	# change this to lerp.
	var tween = get_tree().create_tween()
	tween.tween_property(self, "zoom", Vector2.ONE*default_zoom, 1.0)
		
	
