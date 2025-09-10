extends ApiService

class_name PlayerApi

@export var player_stats: PlayerStatsResource = preload("res://resources/player_stats.tres")

func get_user():
	return await _make_request("/player/" + player_stats.get_device_id(), HTTPClient.METHOD_GET, default_headers, null, _on_get_user)

signal get_user_success(result: Dictionary)
signal get_user_failed(err: Dictionary)

func _on_get_user(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray, endpoint: String):
	var res = handle_data_complete(result, response_code, headers, body, endpoint)
	_handle_and_emit("get_user", res)


func create_user(new_player_stats: Dictionary):
	return await _make_request("/player/", HTTPClient.METHOD_POST, default_headers, new_player_stats, _on_create_user)

signal create_user_success(result: Dictionary)
signal create_user_failed(err: Dictionary)

func _on_create_user(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray, endpoint: String):
	var res = handle_data_complete(result, response_code, headers, body, endpoint)
	_handle_and_emit("create_user", res)

func update_user(new_player_stats: Dictionary):
	return await _make_request(
		"/player/" + player_stats.get_device_id(),
		HTTPClient.METHOD_PATCH,
		default_headers,
		new_player_stats,
		_on_update_user
	)

signal update_user_success(result: Dictionary)
signal update_user_failed(err: Dictionary)

func _on_update_user(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray, endpoint: String):
	var res = handle_data_complete(result, response_code, headers, body, endpoint)
	_handle_and_emit("update_user", res)


# Shared handler to keep structure consistent across API classes
func _handle_and_emit(op: String, res: Variant, update_local: bool = true) -> void:
	print(op)
	if res.ok:
		if update_local:
			_apply_to_resource(op, res.data)
		match op:
			"get_user":
				get_user_success.emit(res.data)
			"create_user":
				create_user_success.emit(res.data)
			"update_user":
				update_user_success.emit(res.data)
			_:
				# For future operations, default to base signal if added
				pass
	else:
		match op:
			"get_user":
				get_user_failed.emit(res.data)
			"create_user":
				create_user_failed.emit(res.data)
			"update_user":
				update_user_failed.emit(res.data)
			_:
				pass


# Apply successful responses to the bound resource
func _apply_to_resource(op: String, data: Dictionary) -> void:
	if player_stats == null:
		return
	print_debug("Applying to resource: " + op)
	match op:
		"get_user", "create_user", "update_user":
			# Both endpoints return a full player payload
			player_stats.compare_to_resource(data)
		_:
			pass
