extends Control


func _on_start_button_pressed() -> void:
	start_game()

func _on_exit_button_pressed() -> void:
	quit_game()

func start_game():
	Game.reset_stats()
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func quit_game():
	get_tree().quit()
