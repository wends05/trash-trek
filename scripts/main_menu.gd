extends Control

@onready var GameTitle = $CanvasLayer2/GameTitle

func _ready():
	is_intro_scene()
	
func _on_start_button_pressed() -> void:
	start_game()

func _on_exit_button_pressed() -> void:
	quit_game()

func is_intro_scene():
	if SceneHandler.last_scene_path == "res://scenes/intro.tscn":
		GameTitle.play("text_pop")
		await GameTitle.animation_finished
		GameTitle.play("flicker")
		await GameTitle.animation_finished
		GameTitle.play("default")
		
func start_game():
	SceneHandler.last_scene_path = get_tree().current_scene.scene_file_path
	Game.reset_stats()
	SceneTransition.change_scene("res://scenes/Main.tscn")

func quit_game():
	get_tree().quit()
