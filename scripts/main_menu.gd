extends Control

@onready var gameTitle = $ParallaxBackground/Misc/GameTitle
@onready var videoPlay = $ParallaxBackground/Misc/VideoStreamPlayer
@onready var camPlay = $AnimationPlayer
@onready var camPos = $Camera2D

func _ready():
	is_intro_scene()
	
func _on_start_button_pressed() -> void:
	start_game()

func _on_exit_button_pressed() -> void:
	quit_game()

func is_intro_scene():
	if SceneHandler.last_scene_path == "res://scenes/intro.tscn":
		camPlay.play("cam_in")
		await camPlay.animation_finished
		gameTitle.play("text_pop")
		videoPlay.paused = true
		await gameTitle.animation_finished
		gameTitle.play("default")
		videoPlay.paused = false
	else:
		camPos.position = Vector2(0, 0)

func start_game():
	SceneHandler.last_scene_path = get_tree().current_scene.scene_file_path
	Game.reset_stats()
	SceneTransition.change_scene("res://scenes/Main.tscn")

func quit_game():
	get_tree().quit()
