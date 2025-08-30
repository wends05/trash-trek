extends Control

@onready var animation = $AnimationPlayer
@onready var play_texture = $PlayButtonGlow
@onready var quit_texture = $QuitButtonGlow

func _ready() -> void:
	animation.play("from_intro_transition")
	play_texture.visible = false
	quit_texture.visible = false

func _on_start_pressed() -> void:
	animation.play("press_play")
	animation.animation_finished.connect(_on_animation_finished)

func _on_start_mouse_entered() -> void:
	quit_texture.visible = false
	play_texture.visible = true
	animation.play("hover_play")
	
func _on_start_mouse_exited() -> void:
	animation.play_backwards("hover_play")
	animation.animation_finished.connect(_on_animation_finished)

func _on_quit_pressed() -> void:
	animation.play("press_quit")
	animation.animation_finished.connect(_on_animation_finished)

func _on_quit_mouse_entered() -> void:
	play_texture.visible = false
	quit_texture.visible = true
	animation.play("hover_quit")

func _on_quit_mouse_exited() -> void:
	animation.play_backwards("hover_quit")
	animation.animation_finished.connect(_on_animation_finished)
	
func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == "press_play":
		start_game()
	if anim_name == "press_quit":
		quit_game()
	if anim_name == "hover_play" and animation.current_animation_position == 0.0:
		play_texture.visible = false
	if anim_name == "hover_quit" and animation.current_animation_position == 0.0:
		quit_texture.visible = false
		
func start_game():
	Game.reset_stats()
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func quit_game():
	get_tree().quit()
