extends Control

@onready var game_title = $ParallaxBackground/Misc/GameTitle
@onready var buttons_player = $Buttons/ButtonsPlayer
@onready var props_player = $PropsPlayer
@onready var cam = $Camera2D

@onready var player = $ParallaxBackground/Player

@onready var start_button = $Buttons/StartButton
@onready var tutorial_button = $Buttons/TutorialButton
@onready var credits_button = $Buttons/CreditsButton
@onready var exit_button = $Buttons/ExitButton

func _ready():
	is_intro_scene()
	cam.make_current()
	
func _on_start_button_pressed() -> void:
	start_game()

func _on_exit_button_pressed() -> void:
	Utils.anim_player(buttons_player, "exit_press")
	await buttons_player.animation_finished
	quit_game()

func _on_tutorial_button_pressed() -> void:
	Utils.anim_player(buttons_player, "tutorial_press")
	await buttons_player.animation_finished

func _on_credits_button_pressed() -> void:
	Utils.anim_player(buttons_player, "credits_press")
	await buttons_player.animation_finished

func is_intro_scene():
	if SceneHandler.last_scene_path == "res://scenes/intro.tscn":
		Utils.anim_player(props_player, "cam_in")
		await props_player.animation_finished
		Utils.anim_player(props_player, "text_pop")
		Utils.anim_player(props_player, "hover_button")
		await game_title.animation_finished
		Utils.anim_player(game_title, "default")
	else:
		Utils.anim_player(props_player, "hover_button")
		cam.position = Vector2(-3, 0)

func start_game():
	player.hide()
	disable_buttons([credits_button, exit_button, start_button, tutorial_button])
	Game.reset_stats()
	SceneHandler.last_scene_path = get_tree().current_scene.scene_file_path
	Utils.anim_player(props_player, "fade_out")
	SceneTransition.change_scene("res://scenes/Main.tscn", Utils.SceneType.Gameplay)

func quit_game():
	get_tree().quit()

func disable_buttons(buttons: Array):
	for button in buttons:
		button.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _on_tutorial_button_mouse_entered() -> void:
	$Buttons/TutorialButton/TutorialLabel.add_theme_color_override("font_color", Color.html("f07a00"))
		
func _on_tutorial_button_mouse_exited() -> void:
	$Buttons/TutorialButton/TutorialLabel.add_theme_color_override("font_color", Color.html("da6800"))

func _on_exit_button_mouse_entered() -> void:
	$Buttons/ExitButton/ExitLabel.add_theme_color_override("font_color", Color.html("f07a00"))

func _on_exit_button_mouse_exited() -> void:
	$Buttons/ExitButton/ExitLabel.add_theme_color_override("font_color", Color.html("da6800"))

func _on_credits_button_mouse_entered() -> void:
	$Buttons/CreditsButton/CreditsLabel.add_theme_color_override("font_color", Color.html("f07a00"))

func _on_credits_button_mouse_exited() -> void:
	$Buttons/CreditsButton/CreditsLabel.add_theme_color_override("font_color", Color.html("da6800"))
