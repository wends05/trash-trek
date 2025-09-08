extends Node

@export var api_base_url: String = "http://127.0.0.1:8000" # change to your server URL

var device_id = ""
var player_stats = {
	"device_id": "",
	"name": "",
	"coins": 0
}

signal get_user_failed(err: Utils.ErrorType)
signal get_user_success

signal ask_user_name
signal user_name_set(name: String)

signal set_user_failed(err: Utils.ErrorType)
signal set_user_success

const SAVE_PATH = "user://device_id.save"

func _ready() -> void:
	device_id = get_device_id()
	print_debug("Device ID: ", device_id)

	get_user_failed.connect(_on_get_user_failed)
	user_name_set.connect(_on_name_set)

func get_device_id() -> String:
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		var saved_id = file.get_line()
		file.close()
		return saved_id
	else:
		var new_id = str(OS.get_unique_id())
		var save_file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
		save_file.store_line(new_id)
		save_file.close()
		return new_id


func get_user():
	var res := await Utils.http_json(self, _on_get_user_success, api_base_url + "/player/" + device_id, HTTPClient.METHOD_GET)
	if res.get("ok", false):
		var data = res.get("data", {})
		player_stats = data
	else:
		var err: Utils.ErrorType = res.get("error", Utils.ErrorType.REQUEST_ERROR)
		get_user_failed.emit(err)

func _on_get_user_success(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
	if response_code >= 200 and response_code < 300:
		var text = body.get_string_from_utf8()

		var json = JSON.new()
		if json.parse(text) == OK:
			player_stats = json
			get_user_success.emit()
		else:
			get_user_failed.emit(Utils.ErrorType.INVALID_JSON)
	else:
		get_user_failed.emit(Utils.ErrorType.HTTP_ERROR)

	var node = get_child(get_child_count() - 1)
	if node is HTTPRequest:
		node.queue_free()

func _on_get_user_failed(error_type: Utils.ErrorType):
	if error_type == Utils.ErrorType.REQUEST_ERROR:
		ask_user_name.emit()

func _on_name_set(set_name: String):
	print(set_name)

	var body := {
		"device_id": device_id,
		"name": set_name,
		"coins": 0
	}
	var res := await Utils.http_json(self, _on_set_user_success, api_base_url + "/player/", HTTPClient.METHOD_POST, [], body)
	if res.get("ok", false):
		var data = res.get("data", {})
		player_stats = data
	else:
		var err: Utils.ErrorType = res.get("error", Utils.ErrorType.REQUEST_ERROR)
		set_user_failed.emit(err)

func _on_set_user_success(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
	if response_code >= 200 and response_code < 300:
		var text = body.get_string_from_utf8()

		var json = JSON.new()
		if json.parse(text) == OK:
			player_stats = json
			set_user_success.emit()
		else:
			set_user_failed.emit(Utils.ErrorType.INVALID_JSON)
	else:
		set_user_failed.emit(Utils.ErrorType.HTTP_ERROR)

	var node = get_child(get_child_count() - 1)
	if node is HTTPRequest:
		node.queue_free()
