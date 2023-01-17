extends TextureRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func draw_cards():
	pass


func _on_CardDeck_gui_input(event):
	# accept a mouse click in the region, or
	# "ui_accept" keyboard input anywhere if card has focus
	if self.has_focus() and event.is_action("ui_accept"):
		draw_cards()
		
