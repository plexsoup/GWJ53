extends Camera2D

export var current_zoom = 2.0
export var max_zoom = 3.0
export var min_zoom = 1.0


# Called when the node enters the scene tree for the first time.
func _ready():
	set_zoom(Vector2(current_zoom, current_zoom))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _unhandled_input(event):
	if event.is_action("camera_zoom_in") and Input.is_action_just_pressed("camera_zoom_in"):
		
		if get_zoom().x > min_zoom:
			set_zoom( get_zoom() - Vector2(0.1, 0.1) )

	elif event.is_action("camera_zoom_out") and Input.is_action_just_pressed("camera_zoom_out"):
		if get_zoom().x < max_zoom:
			set_zoom( get_zoom() + Vector2(0.1, 0.1))
