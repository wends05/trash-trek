extends Control

func _on_resume_button_pressed() -> void:
	Game.update_ui_state.emit(Utils.UIStateType.PauseMenu)
	Game.update_game_state.emit(Utils.GameStateType.Play)

func _on_restart_button_pressed() -> void:
	Game.update_game_state.emit(Utils.GameStateType.Play)
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_main_menu_button_pressed() -> void:
	Game.update_game_state.emit(Utils.GameStateType.Play)
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
	
func _on_quit_button_pressed() -> void:
	get_tree().quit()
	
