extends Slider


export var bus_name: String = "Master"

export var audio_duration_after_drag_ended: float = 0.75
export(NodePath) var example_audio_path
onready var example_audio = get_node(example_audio_path)

var bus_index: int
var timer: SceneTreeTimer


func _ready():
	bus_index = AudioServer.get_bus_index(bus_name)
	
	assert(bus_index != -1, "No bus with the given name: " + bus_name + " exists!" +
	"\nObject: " + self.name + 
	"\nScene: " + get_tree().current_scene.get_name())
	
	var converted_val = pow(10, AudioServer.get_bus_volume_db(bus_index) / 20)
	self.value = converted_val
	
	# connect signals
	connect("value_changed", self, "_on_value_changed")


func _on_value_changed(value: float):
	# "stop" the currently running timer, to continue playing audio while
	# changing the volume
	if timer:
		if timer.is_connected("timeout", self, "_on_timeout"):
			timer.disconnect("timeout", self, "_on_timeout")
	timer = get_tree().create_timer(audio_duration_after_drag_ended)
	timer.connect("timeout", self, "_on_timeout")

	# set the volume in db or mute if min value was reached
	if value == self.min_value:
		AudioServer.set_bus_mute(bus_index, true)
	else:
		AudioServer.set_bus_mute(bus_index, false)
		AudioServer.set_bus_volume_db(bus_index, log(value) * 20)
	
	if not example_audio.playing:
		example_audio.play()


func _on_timeout():
	example_audio.stop()
