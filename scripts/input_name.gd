extends Control

@onready var loading_label = $"Container/Loading"

@onready var name_input = $Container/NameInput
@onready var enter_button = $Container/Enter
@onready var message_label = $Container/Message

var loading = true

func _ready() -> void:
	PlayerApi.set_user_success.connect(_on_set_user_success)
	PlayerApi.set_user_failed.connect(_on_set_user_failed)
	PlayerApi.get_user_success.connect(_on_get_user_success)
	PlayerApi.get_user_failed.connect(_on_get_user_failed)
	PlayerApi.get_user()

func _on_get_user_failed(err: Utils.ErrorType) -> void:
	loading = false
	loading_label.visible = false
	name_input.visible = true
	enter_button.visible = true
	message_label.visible = true

func _on_get_user_success() -> void:
	go_to_main()

func _on_set_user_failed(err: Utils.ErrorType) -> void:
	print_debug("Set user failed: " + Utils.get_enum_name(Utils.ErrorType, err))
	name_input.text = ""
	message_label.text = "An error has occured"

func _on_set_user_success() -> void:
	name_input.text = ""
	message_label.text = "Name set successfully"
	go_to_main()

func _on_enter_pressed() -> void:
	message_label.text = ""
	print_debug("Name: " + name_input.text)
	PlayerApi.user_name_set.emit(name_input.text)

func go_to_main():
	get_tree().change_scene_to_file("res://scenes/intro.tscn")
