extends OptionButton


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	#warning-ignore:RETURN_VALUE_DISCARDED
	connect("item_selected", self, "change_locale")

func change_locale(index):
	if index == 0: # english
		TranslationServer.set_locale("en")
	elif index == 1: # espanol
		TranslationServer.set_locale("es")
	elif index == 2: # hanyu
		TranslationServer.set_locale("zh")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
