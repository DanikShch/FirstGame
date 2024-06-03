extends Node

@onready var pause_menu = $"../CanvasLayer/PauseMenu"
@onready var player = $"../Player/Player"

var game_paused = false
var save_path = "user://savegame.save"

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

func save_game():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(Inventory.coin)
	file.store_var(Inventory.wood)
	file.store_var(Inventory.stone)
	file.store_var(Inventory.gem)
	file.store_var(player.position.x)
	file.store_var(player.position.y)
	
func load_game():
	var file = FileAccess.open(save_path, FileAccess.READ)
	Inventory.coin = file.get_var(Inventory.coin)
	Inventory.wood = file.get_var(Inventory.wood)
	Inventory.stone = file.get_var(Inventory.stone)
	Inventory.gem = file.get_var(Inventory.gem)
	player.position.x = file.get_var(player.position.x)
	player.position.y = file.get_var(player.position.y)

func _on_save_pressed():
	save_game()
	game_paused = !game_paused

func _on_load_pressed():
	load_game()
	game_paused = !game_paused
