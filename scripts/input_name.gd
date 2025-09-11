extends Control

@onready var loading_label = $"Container/Loading"
@onready var name_input = $Container/NameInput
@onready var enter_button = $Container/Enter
@onready var message_label = $Container/Message
@onready var timer: Timer = $Timer

var show_timer = false

func _ready() -> void:
	PlayerApi.get_user_failed.connect(_on_get_user_failed)
	PlayerApi.get_user_success.connect(_on_get_user_success)
	PlayerApi.create_user_failed.connect(_on_create_user_failed)
	PlayerApi.create_user_success.connect(_on_create_user_success)
	PlayerApi.get_user()
	timer.start()
	timer.timeout.connect(show_countdown)

func _on_get_user_success(_res: Dictionary) -> void:
	go_to_main()

func _on_get_user_failed(_err: Dictionary) -> void:
	loading_label.visible = false
	name_input.visible = true
	enter_button.visible = true
	message_label.visible = true
	timer.stop()

func _on_create_user_success(_res: Dictionary) -> void:
	name_input.text = ""
	message_label.text = "Name set successfully"
	go_to_main()

func _on_create_user_failed(err: Dictionary) -> void:
	var error_message = ApiService.parse_error_message(err)
	if error_message.contains("string_too_short"):
		message_label.text = "Name must be at least 1 characters long"
	else:
		message_label.text = error_message
	message_label.visible = true

func _on_enter_pressed() -> void:
	var player_stats = ResourceLoader.load("res://resources/player_stats.tres")
	message_label.text = ""
	PlayerApi.create_user({
		"device_id": player_stats.get_device_id(),
		"name": name_input.text,
	})

func _process(_delta: float) -> void:
	if show_timer:
		loading_label.text = "Loading Game %.f" % timer.time_left
	
func show_countdown():
	show_timer = true
	timer.start(5)
	timer.timeout.disconnect(show_countdown)
	timer.timeout.connect(go_to_main)
	
	
func go_to_main():
	get_tree().change_scene_to_file("res://scenes/intro.tscn")
