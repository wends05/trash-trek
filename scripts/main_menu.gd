extends Control

@onready var animation = $AnimationPlayer
@onready var play_texture = $CanvasLayer/PlayButtonGlow
@onready var quit_texture = $CanvasLayer/QuitButtonGlow
@onready var play_button = $Start
@onready var quit_button = $Quit

func _ready() -> void:
	$CanvasLayer.show()
	play_button.disabled = true
	quit_button.disabled = true
	play_button.hide()
	quit_button.hide()
	play_texture.hide()
	quit_texture.hide()
	get_tree().process_frame.connect(_start_menu_animation, CONNECT_ONE_SHOT)
	
func _start_menu_animation() -> void:
	$CanvasLayer.show()
	animation.play("from_intro_transition")
	animation.animation_finished.connect(_on_animation_finished)
	
func _on_start_pressed() -> void:
	animation.play("press_play")
	animation.animation_finished.connect(_on_animation_finished)
	
func _on_start_mouse_entered() -> void:
	if play_button.disabled:
		return
	quit_texture.hide()
	play_texture.show()
	animation.play("hover_play")
	
func _on_start_mouse_exited() -> void:
	animation.play_backwards("hover_play")
	animation.animation_finished.connect(_on_animation_finished)

func _on_quit_pressed() -> void:
	animation.play("press_quit")
	animation.animation_finished.connect(_on_animation_finished)

func _on_quit_mouse_entered() -> void:
	if quit_button.disabled:
		return
	play_texture.hide()
	quit_texture.show()
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
		play_texture.hide()
	if anim_name == "hover_quit" and animation.current_animation_position == 0.0:
		quit_texture.hide()
	if anim_name == "from_intro_transition":
		play_button.disabled = false
		quit_button.disabled = false
		play_button.show()
		quit_button.show()
		
func start_game():
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func quit_game():
	get_tree().quit()
