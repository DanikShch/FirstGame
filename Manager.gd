extends Node

@onready var pause_menu = $"../CanvasLayer/PauseMenu"

var game_paused = false

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		game_paused = !game_paused
	get_tree().paused = game_paused
	if game_paused:
		pause_menu.show()
	else:
		pause_menu.hide()




func _on_resume_pressed():
	game_paused = !game_paused
	
	


func _on_quit_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://menu.tscn")


func _on_menu_button_pressed():
	game_paused = !game_paused
