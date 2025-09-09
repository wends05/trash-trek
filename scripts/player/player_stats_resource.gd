extends Resource

class_name PlayerStatsResource

@export var device_id: String
@export var name: String
@export var coins: int
@export var high_score: float
@export var upgrades: Array = []
@export var lastModified: String

const SAVE_PATH = "user://device_id.save"

func to_dict() -> Dictionary:
	return {
		"device_id": device_id,
		"name": name,
		"coins": coins,
		"high_score": high_score,
		"upgrades": upgrades,
		"lastModified": lastModified
	}


func get_device_id():
	print("getting device id")
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


func _update_last_modified() -> void:
	lastModified = Time.get_datetime_string_from_datetime_dict(Time.get_datetime_dict_from_system(), false)
	_save()

func _save() -> void:
	ResourceSaver.save(self)

func save_stats(player_stats: Dictionary) -> void:
	device_id = player_stats.get("device_id", device_id)
	name = player_stats.get("name", name)
	coins = player_stats.get("coins", coins)
	high_score = player_stats.get("high_score", high_score)
	upgrades = player_stats.get("upgrades", upgrades)
	lastModified = player_stats.get("lastModified", lastModified)
	_update_last_modified()


func save_name(new_name: String) -> void:
	name = new_name
	_update_last_modified()

func update_coins(new_coins: int) -> void:
	coins = new_coins
	_update_last_modified()

func update_high_score(new_high_score: float) -> void:
	high_score = max(high_score, new_high_score)
	_update_last_modified()

func update_upgrades(new_upgrades: Array) -> void:
	upgrades = new_upgrades
	_update_last_modified()
