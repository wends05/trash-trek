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
	world_player.play_backwards("fade_in")
	SceneTransition.credits_end.emit()
	$".".queue_free()
	
func _on_resized() -> void:
	set_header_and_footer()

func _ready() -> void:
	world_player.play("fade_in")
	resized.connect(_on_resized)
	set_header_and_footer()
