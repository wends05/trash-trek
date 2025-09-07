extends Node

enum TrashType {
	Recyclable,
	Biodegradable,
	ToxicWaste
}

enum GameStateType {
	Pause,
	Play,
}

enum UIStateType {
	Settings,
	PauseMenu,
	GameOver,
}

enum GameOverReason {
	None,
	OutOfBounds,
	Fell,
	OutOfEnergy,
}

enum PlayerMotion {
	Jump,
	Fall,
	Run,
	Hurt
}

enum ErrorType {
	OK,
	REQUEST_ERROR,
	INVALID_JSON,
	HTTP_ERROR
}

const TRASHES = [
	preload("res://resources/trash_resource/biodegradable/branches.tres"),
	preload("res://resources/trash_resource/biodegradable/crumpled.tres"),
	preload("res://resources/trash_resource/biodegradable/pile_of_leaves.tres"),
	preload("res://resources/trash_resource/recyclable/box.tres"),
	preload("res://resources/trash_resource/recyclable/tin_can.tres"),
	preload("res://resources/trash_resource/recyclable/water_bottle.tres"),
	preload("res://resources/trash_resource/toxic_waste/battery.tres"),
	preload("res://resources/trash_resource/toxic_waste/face_mask.tres"),
	preload("res://resources/trash_resource/toxic_waste/gloves.tres"),
	]

const TRASHBINS = [
	preload("res://resources/trashbins/Recyclable.tres"),
	preload("res://resources/trashbins/Biodegradable.tres"),
	preload("res://resources/trashbins/ToxicWaste.tres"),
]

const TRASHBINICONS := [
	preload("res://assets/trashbins/labels/Recyclable.png"),
	preload("res://assets/trashbins/labels/Biodegradable.png"),
	preload("res://assets/trashbins/labels/ToxicWaste.png")
]

func get_enum_name(enum_dict: Dictionary, value: int) -> String:
	for key in enum_dict.keys():
		if enum_dict[key] == value:
			return key
	return ""

func get_random_trash_item() -> TrashResource:
	var items = TRASHES
	return items[randi() % items.size()]

func get_trash_bin(trash_type: Utils.TrashType) -> TrashBinResource:
	var items = TRASHBINS
	return items[trash_type]

func get_trash_bin_icon(trash_type: Utils.TrashType) -> Texture:
	var items = TRASHBINICONS
	return items[trash_type]

func http_json(
	node: Node,
	success_callable: Callable,
	url: String,
	method: int = HTTPClient.METHOD_GET,
	headers: PackedStringArray = PackedStringArray(),
	body: Variant = null,
) -> Dictionary:
	var req := HTTPRequest.new()
	node.add_child(req)
	req.request_completed.connect(success_callable)

	var body_str := ""
	if body != null:
		match typeof(body):
			TYPE_DICTIONARY, TYPE_ARRAY:
				body_str = JSON.stringify(body)
				headers.append("Content-Type: application/json")
			TYPE_STRING:
				body_str = body
			_:
				body_str = str(body)

	var err := req.request(url, headers, method, body_str)
	print_debug("HTTP request: ", err)
	if err != OK:
		printerr("HTTP request failed: ", err)
		# req.queue_free()
		return {"ok": false, "error": ErrorType.REQUEST_ERROR, "code": 0}

	var result = await req.request_completed
	# req.queue_free()

	var response_code: int = result[1]
	var body_bytes: PackedByteArray = result[3]

	if response_code >= 200 and response_code < 300:
		var text := body_bytes.get_string_from_utf8()
		var json := JSON.new()
		if json.parse(text) == OK:
			return {"ok": true, "code": response_code, "data": json}
		else:
			return {"ok": false, "error": ErrorType.INVALID_JSON, "code": response_code}
	else:
		return {"ok": false, "error": ErrorType.HTTP_ERROR, "code": response_code}
