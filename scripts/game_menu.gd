extends Control

@onready var resume_button = $ResumeButton
@onready var restart_button = $RestartButton
@onready var retry_button = $RetryButton
@onready var menu_button = $MainMenuButton
@onready var quit_button = $QuitButton

@onready var hover_player = $HoverPlayer
@onready var button_player = $ButtonPlayer
@onready var trans_player = $TransPlayer
@onready var text_player = $"../TextPlayer"
@onready var ui : UI = $".."

func _on_resume_button_pressed() -> void:
	check_for_pause()
	ui.disable_buttons(ui.my_buttons)
	ui.game_menu_animation(false)
	await text_player.animation_finished
	Game.update_game_state.emit(Utils.GameStateType.Play)
	Game.update_ui_state.emit(Utils.UIStateType.PauseMenu)
	
func _on_restart_button_pressed() -> void:
	check_for_pause()
	Utils.anim_player(button_player, "restart_press")
	await button_player.animation_finished
	ui.game_menu_animation(false)
	await text_player.animation_finished
	Game.update_game_state.emit(Utils.GameStateType.Play)
	get_tree().change_scene_to_file("res://scenes/Main.tscn")
	Game.is_game_over = false
	Game.reset_stats()

func _on_retry_button_pressed() -> void:
	check_for_pause()
	ui.game_menu_animation(false)
	await text_player.animation_finished
	Game.update_game_state.emit(Utils.GameStateType.Play)
	get_tree().change_scene_to_file("res://scenes/Main.tscn")
	Game.is_game_over = false
	Game.reset_stats()
	
func _on_main_menu_button_pressed() -> void:
	check_for_pause()
	Utils.anim_player(button_player, "main_menu_press")
	await button_player.animation_finished
	ui.game_menu_animation(false)
	await text_player.animation_finished
	Game.update_game_state.emit(Utils.GameStateType.Play)
	Game.is_game_over = false
	Game.reset_stats()
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")

func _on_quit_button_pressed() -> void:
	Utils.anim_player(button_player, "quit_press")
	await button_player.animation_finished
	get_tree().quit()

func check_for_pause():
	if Game.is_game_pause:
		Game.is_game_pause = false

func _on_restart_button_mouse_entered() -> void:
	$RestartButton/RestartLabel.add_theme_color_override("font_color", Color.html("f07a00"))

func _on_restart_button_mouse_exited() -> void:
	$RestartButton/RestartLabel.add_theme_color_override("font_color", Color.html("da6800"))

func _on_main_menu_button_mouse_entered() -> void:
	$MainMenuButton/MainMenuLabel.add_theme_color_override("font_color", Color.html("f07a00"))

func _on_main_menu_button_mouse_exited() -> void:
	$MainMenuButton/MainMenuLabel.add_theme_color_override("font_color", Color.html("da6800"))

func _on_quit_button_mouse_entered() -> void:
	$QuitButton/ExitLabel.add_theme_color_override("font_color", Color.html("f07a00"))

func _on_quit_button_mouse_exited() -> void:
	$QuitButton/ExitLabel.add_theme_color_override("font_color", Color.html("da6800"))
