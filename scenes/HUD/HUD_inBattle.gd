extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_player_won(cashPrize):
	$PopupDialog.popup_centered_ratio(0.5)
	$PopupDialog/MarginContainer/VBoxContainer/CashPrize.text = "You've earned: " + str(cashPrize) + " scrap!"
