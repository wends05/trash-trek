extends ApiService


##
## COMMENT: Might not use
class_name ShopApi

@export var player_stats: PlayerStatsResource

func get_shop_items():
	return await _make_request("/shop/items", HTTPClient.METHOD_GET, default_headers, null, _on_get_shop_items)

signal get_shop_items_success(result: Variant)
signal get_shop_items_failed(err: Dictionary)

func _on_get_shop_items(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray, endpoint: String):
	var res = handle_data_complete(result, response_code, headers, body, endpoint)
	_handle_and_emit("get_shop_items", res)


func purchase_upgrade(item_id: String):
	return await _make_request("/shop/purchase", HTTPClient.METHOD_POST, default_headers, {"item_id": item_id}, _on_purchase_upgrade)

signal purchase_upgrade_success(result: Variant)
signal purchase_upgrade_failed(err: Dictionary)

func _on_purchase_upgrade(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray, endpoint: String):
	var res = handle_data_complete(result, response_code, headers, body, endpoint)
	_handle_and_emit("purchase_item", res)

func purchase_skin(skin_id: String):
	return await _make_request("/shop/purchase", HTTPClient.METHOD_POST, default_headers, {"skin_id": skin_id}, _on_purchase_skin)

signal purchase_skin_success(result: Dictionary)
signal purchase_skin_failed(err: Dictionary)

func _on_purchase_skin(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray, endpoint: String):
	var res = handle_data_complete(result, response_code, headers, body, endpoint)
	_handle_and_emit("purchase_skin", res)

func _handle_and_emit(op: String, res: Variant):
	if res.ok:
		match op:
			"get_shop_items":
				get_shop_items_success.emit(res.data)
			"purchase_upgrade":
				purchase_upgrade_success.emit(res.data)
			"purchase_skin":
				purchase_skin_success.emit(res.data)
			_:
				pass
	else:
		match op:
			"get_shop_items":
				get_shop_items_failed.emit(res.data)
			"purchase_item":
				purchase_upgrade_failed.emit(res.data)
			"purchase_skin":
				purchase_skin_failed.emit(res.data)
			_:
				pass
