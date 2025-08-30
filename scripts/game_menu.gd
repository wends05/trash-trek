extends Control

@onready var resume_button = $ResumeButton
@onready var restart_button = $RestartButton
@onready var retry_button = $RetryButton

func _on_resume_button_pressed() -> void:
	check_for_pause()
	Game.update_ui_state.emit(Utils.UIStateType.PauseMenu)
	Game.update_game_state.emit(Utils.GameStateType.Play)
	
func _on_restart_button_pressed() -> void:
	Game.update_game_state.emit(Utils.GameStateType.Play)
	get_tree().change_scene_to_file("res://scenes/Main.tscn")
	Game.reset_stats()

func _on_retry_button_pressed() -> void:
	Game.update_game_state.emit(Utils.GameStateType.Play)
	get_tree().change_scene_to_file("res://scenes/Main.tscn")
	Game.is_game_over = false
	Game.reset_stats()
	
func _on_main_menu_button_pressed() -> void:
	Game.update_game_state.emit(Utils.GameStateType.Play)
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
	Game.is_game_over = false
	Game.reset_stats()
	
func _on_quit_button_pressed() -> void:
	get_tree().quit()

func check_for_pause():
	if Game.is_game_pause:
		Game.is_game_pause = false
