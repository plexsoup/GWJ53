extends TextureProgress


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	value = lerp(value, Global.player.health / Global.player.health_max, delta * 3)
	$"%HPLabel".text = str(Global.player.health)
