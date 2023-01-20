extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_player_won(cashPrize):
	$Control/WinDialog.popup_centered_ratio(0.5)
	$Control/WinDialog/MarginContainer/VBoxContainer/CashPrize.text = "You've earned: " + str(cashPrize) + " scrap!"


func _on_PauseButton_pressed():
	$Control/HBoxContainer/PauseButton/PauseDialog.popup_centered_ratio(0.618)
	get_tree().paused = true
	


func _on_HelpButton_pressed():
	pass # Replace with function body.


func _on_ResumeButton_pressed():
	$Control/HBoxContainer/PauseButton/PauseDialog.hide()
	get_tree().paused = false
	

func _on_QuitToMenuButton_pressed():
	Global.stage_manager.change_scene("res://scenes/Menus/MainMenu02.tscn")
	Global.battles_completed = []
	get_tree().paused = false


func _on_PauseDialog_popup_hide():
	get_tree().paused = false
