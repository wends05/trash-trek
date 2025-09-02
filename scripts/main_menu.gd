extends Control

func start_game():
	Game.reset_stats()
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func quit_game():
	get_tree().quit()
