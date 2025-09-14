class_name ScrollingCredits
extends Credits

@onready var header_space : Control = %HeaderSpace
@onready var footer_space : Control = %FooterSpace
@onready var credits_label : Control = %CreditsLabel
@onready var world_player = $WorldPlayer

func set_header_and_footer() -> void:
	header_space.custom_minimum_size.y = size.y
	footer_space.custom_minimum_size.y = size.y
	credits_label.custom_minimum_size.x = size.x
	
func _on_scroll_container_end_reached() -> void:
	SceneTransition.credits_end.emit()
	AudioManager.play_music(preload("res://audios/main_menu3.mp3"), -3)
	$".".queue_free()
	
func _on_resized() -> void:
	set_header_and_footer()

func _ready() -> void:
	AudioManager.play_music(preload("res://audios/credits.mp3"), -3)
	resized.connect(_on_resized)
	set_header_and_footer()
