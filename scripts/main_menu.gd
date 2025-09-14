extends Control

@onready var game_title = $ParallaxBackground/Misc/GameTitle
@onready var buttons_player = $Buttons/ButtonsPlayer
@onready var props_player = $PropsPlayer
@onready var cam = $Camera2D

@onready var player = $ParallaxBackground/Player

@export var credits_scene: PackedScene
@export var game_scene: PackedScene

@onready var start_button = $Buttons/StartButton
@onready var tutorial_button = $Buttons/TutorialButton
@onready var credits_button = $Buttons/CreditsButton
@onready var exit_button = $Buttons/ExitButton

@onready var scene_container = $SceneContainer


func _ready():
	AudioManager.play_music(preload("res://audios/main_menu3.mp3"))
	SceneTransition.credits_end.connect(exit_credits)
	is_intro_scene()
	cam.make_current()

func exit_credits():
	enable_buttons([credits_button, exit_button, start_button, tutorial_button])
	props_player.play_backwards("credit_scene")
	await props_player.animation_finished
	Utils.anim_player(props_player, "hover_button")

func _on_start_button_pressed() -> void:
	start_game()

func _on_exit_button_pressed() -> void:
	Utils.anim_player(buttons_player, "exit_press")
	await buttons_player.animation_finished
	quit_game()

func _on_tutorial_button_pressed() -> void:
	Utils.anim_player(buttons_player, "tutorial_press")
	await buttons_player.animation_finished
	get_tree().change_scene_to_file("res://scenes/Tutorial.tscn")

func _on_credits_button_pressed() -> void:

	Utils.anim_player(buttons_player, "credits_press")
	await buttons_player.animation_finished
	disable_buttons([credits_button, exit_button, start_button, tutorial_button])
	Utils.anim_player(props_player, "credit_scene")
	await props_player.animation_finished
	SceneTransition.change_scene(credits_scene, Utils.SceneType.Credits, scene_container)
	
func is_intro_scene():
	if SceneHandler.last_scene_path == "res://scenes/intro.tscn":
		Utils.anim_player(props_player, "cam_in")
		await props_player.animation_finished
		game_title.play("text_pop")
		Utils.anim_player(props_player, "hover_button")
		await game_title.animation_finished
		game_title.play("default")
	else:
		Utils.anim_player(props_player, "hover_button")
		cam.position = Vector2(-3, 0)

func start_game():
	player.hide()
	disable_buttons([credits_button, exit_button, start_button, tutorial_button])
	Game.reset_stats()
	SceneHandler.last_scene_path = get_tree().current_scene.scene_file_path
	Utils.anim_player(props_player, "fade_out")
	SceneTransition.change_scene(game_scene, Utils.SceneType.Gameplay)

func quit_game():
	#AudioManager.play_sfx(preload("res://audios/press_button.mp3"), -2)
	get_tree().quit()

func disable_buttons(buttons: Array):
	for button in buttons:
		button.mouse_filter = Control.MOUSE_FILTER_IGNORE

func enable_buttons(buttons: Array):
	for button in buttons:
		button.mouse_filter = Control.MOUSE_FILTER_PASS

func _on_tutorial_button_mouse_entered() -> void:
	#AudioManager.play_sfx(preload("res://audios/hover_button.mp3"), -3)
	$Buttons/TutorialButton/TutorialLabel.add_theme_color_override("font_color", Color.html("f07a00"))
		
func _on_tutorial_button_mouse_exited() -> void:
	$Buttons/TutorialButton/TutorialLabel.add_theme_color_override("font_color", Color.html("da6800"))

func _on_exit_button_mouse_entered() -> void:
	#AudioManager.play_sfx(preload("res://audios/hover_button.mp3"), -3)
	$Buttons/ExitButton/ExitLabel.add_theme_color_override("font_color", Color.html("f07a00"))

func _on_exit_button_mouse_exited() -> void:
	$Buttons/ExitButton/ExitLabel.add_theme_color_override("font_color", Color.html("da6800"))

func _on_credits_button_mouse_entered() -> void:
	#AudioManager.play_sfx(preload("res://audios/hover_button.mp3"), -3)
	$Buttons/CreditsButton/CreditsLabel.add_theme_color_override("font_color", Color.html("f07a00"))

func _on_credits_button_mouse_exited() -> void:
	$Buttons/CreditsButton/CreditsLabel.add_theme_color_override("font_color", Color.html("da6800"))


func _on_shop_button_pressed() -> void:
	SceneHandler.last_scene_path = get_tree().current_scene.scene_file_path
	get_tree().change_scene_to_file("res://scenes/shop/shop_interface.tscn")


func _on_trophy_button_pressed() -> void:
	SceneHandler.last_scene_path = get_tree().current_scene.scene_file_path
	get_tree().change_scene_to_file("res://scenes/leaderboards.tscn")


func _on_profile_button_pressed() -> void:
	SceneHandler.last_scene_path = get_tree().current_scene.scene_file_path
	get_tree().change_scene_to_file("res://scenes/profile/profile.tscn")
