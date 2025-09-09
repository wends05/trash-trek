extends Node

class_name ApiService

@export var base_url: String = "http://127.0.0.1:8000"
@export var default_headers = PackedStringArray(["Content-Type: application/json"])

signal request_complete(endpoint: String, data: Dictionary)

func _make_request(
	endpoint: String,
	method: HTTPClient.Method,
	headers: PackedStringArray,
	body: Variant,
	on_request_complete: Callable
):
	var http_request := HTTPRequest.new()
	http_request.request_completed.connect(on_request_complete.bind(endpoint))
	add_child(http_request)

	var final_headers = []
	for k in default_headers:
		final_headers.append(k)
	for k in headers:
		final_headers.append(k)

	var url = "%s%s" % [base_url, endpoint]
	var body_str: String = JSON.stringify(body) if typeof(body) == TYPE_DICTIONARY or typeof(body) == TYPE_ARRAY else ""

	var err = http_request.request(url, final_headers, method, body_str)
	if err != OK:
		push_error("Request failed: %s" % err)

func handle_data_complete(
	_result: int,
	response_code: int,
	_headers: PackedStringArray,
	body: PackedByteArray,
	endpoint: String
):
	var result = {"ok": false, "code": response_code, "data": {}}
	
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	result.data = json.data


	result.ok = response_code >= 200 and response_code < 300
	if result.ok:
		print_debug("🌐 Success Response from %s: %s" % [endpoint, JSON.stringify(result.data, "\t")])
	else:
		print_debug("🌐 Error Response from %s: %s" % [endpoint, JSON.stringify(result.data, "\t")])

	request_complete.emit(endpoint, result)
	return result

static func parse_error_message(err: Dictionary, prefix: String = "Error") -> String:
	if not err.has("detail"):
		return "%s: Unknown error" % prefix
	
	var detail = err["detail"]
	
	if detail is Array:
		return _parse_array_error(detail, prefix)
	elif detail is Dictionary:
		return _parse_dictionary_error(detail, prefix)
	else:
		return "%s: Unknown error" % prefix

static func _parse_array_error(detail_array: Array, prefix: String) -> String:
	if detail_array.is_empty():
		return "%s: Unknown error" % prefix

	var first_error = detail_array[0]
	if not first_error is Dictionary:
		return "%s: Unknown error" % prefix

	if first_error.has("type"):
		return "%s: %s" % [prefix, str(first_error["type"])]
	elif first_error.has("message"):
		return "%s: %s" % [prefix, str(first_error["message"])]
	else:
		return "%s: Unknown error" % prefix

static func _parse_dictionary_error(detail_dict: Dictionary, prefix: String) -> String:
	if detail_dict.has("message"):
		return "%s: %s" % [prefix, str(detail_dict["message"])]
	else:
		return "%s: Unknown error" % prefix
