extends Control

@onready var intro_player = $IntroPlayer

func _ready() -> void:
	Utils.anim_player(intro_player, "introduction")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	SceneHandler.last_scene_path = get_tree().current_scene.scene_file_path
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
