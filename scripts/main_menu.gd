extends Control

@onready var game_title = $ParallaxBackground/Misc/GameTitle
@onready var cam_play = $AnimationPlayer
@onready var cam_pos = $Camera2D
@onready var player = $ParallaxBackground/Player

func _ready():
	is_intro_scene()
	cam_pos.make_current()
	
func _on_start_button_pressed() -> void:
	start_game()

func _on_exit_button_pressed() -> void:
	quit_game()

func is_intro_scene():
	if SceneHandler.last_scene_path == "res://scenes/intro.tscn":
		cam_play.play("cam_in")
		await cam_play.animation_finished
		game_title.play("text_pop")
		await game_title.animation_finished
		game_title.play("default")
	else:
		cam_pos.position = Vector2(-3, 0)

func start_game():
	SceneHandler.last_scene_path = get_tree().current_scene.scene_file_path
	Game.reset_stats()
	player.hide()
	cam_play.play("fade_out")
	SceneTransition.change_scene("res://scenes/Main.tscn")
	
	
func quit_game():
	get_tree().quit()
