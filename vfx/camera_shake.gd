extends Node
# Courtesy of KidsCanCode: http://kidscancode.org/godot_recipes/3.x/2d/screen_shake/ (this may change in the near future, so it may require a search)

# If you intend to use this, don't forget to turn on camera rotation! And keep in mind that smaller numbers are often the most useful - huge numbers make this thing *really* shake

# 3.5.x
export var decay = 0.8  # How quickly the shaking stops [0, 1].
export var max_offset = Vector2(100, 75)  # Maximum hor/ver shake in pixels.
export var max_roll = 0.1  # Maximum rotation in radians (use sparingly).
export (NodePath) var target  # Assign the node this camera will follow.

# 4.0.x
# @export var decay := 0.8  # How quickly the shaking stops [0, 1].
# @export var max_offset := Vector2(100, 75)  # Maximum hor/ver shake in pixels.
# @export var max_roll := 0.1  # Maximum rotation in radians (use sparingly).
# @export (NodePath) var target  # Assign the node this camera will follow.

var camera

var trauma = 0.0  # Current shake strength.
var trauma_power = 2  # Trauma exponent. Use [2, 3].

# 3.5.x
onready var noise = OpenSimplexNoise.new()

# 4.0.x
# @onready var noise = OpenSimplexNoise.new()

var noise_y = 0

func _ready():
	noise.seed = randi()
	noise.period = 4
	noise.octaves = 2
	if get_parent().is_class("Camera2D"):
		camera = get_parent()
	else:
		printerr("Camera Shake should be a child of a Camera2D node")

func set_trauma(value) -> void: # Call this if you want to set the trauma value to a certain, specific amount
	trauma = value

func add_trauma(amount = 0): # Call this in order to cause the camera to shake once
	trauma = min(trauma + amount, 1.0)

func _process(delta):
	if target:
		camera.global_position = get_node(target).global_position
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		shake()

func shake():
	var amount = pow(trauma, trauma_power)
	noise_y += 1
	camera.rotation = max_roll * amount * noise.get_noise_2d(noise.seed, noise_y)
	camera.offset.x = max_offset.x * amount * noise.get_noise_2d(noise.seed*2, noise_y)
	camera.offset.y = max_offset.y * amount * noise.get_noise_2d(noise.seed*3, noise_y)
