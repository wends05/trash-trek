extends Resource

class_name PlayerStatsResource

@export var device_id: String
@export var name: String
@export var coins: int
@export var high_score: float
@export var upgrades: Dictionary = {}
@export var skins: Array = []
@export var lastModified: String

const SAVE_PATH = "user://device_id.save"
const PLAYER_STATS_SAVE_PATH = "user://player_stats.tres"

signal coins_updated(value: int)

static func get_instance():
	if not ResourceLoader.exists(PLAYER_STATS_SAVE_PATH):
		ResourceSaver.save(PlayerStatsResource.new(), PLAYER_STATS_SAVE_PATH)
	return ResourceLoader.load(PLAYER_STATS_SAVE_PATH)

func _ready() -> void:
	pass

## info
func to_dict() -> Dictionary:
	return {
		"device_id": device_id,
		"name": name,
		"coins": coins,
		"high_score": high_score,
		"upgrades": upgrades,
		"skins": skins,
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

## saving
func _update_last_modified() -> void:
	lastModified = Time.get_datetime_string_from_datetime_dict(Time.get_datetime_dict_from_system(), false)
	_save()

func _save() -> void:
	coins_updated.emit(coins)
	ResourceSaver.save(self)

func compare_to_resource(player_stats: Dictionary) -> void:
	var db_last_modified = Time.get_unix_time_from_datetime_string(player_stats.get("lastModified"))
	var local_last_modified = Time.get_unix_time_from_datetime_string(lastModified)

	print_debug("DB last modified: ", db_last_modified)
	print_debug("Local last modified: ", local_last_modified)
	
	print_debug(db_last_modified > local_last_modified)
	if db_last_modified > local_last_modified:
		save_stats(player_stats)

func save_stats(player_stats: Dictionary) -> void:
	device_id = player_stats.get("device_id", device_id)
	name = player_stats.get("name", name)
	coins = player_stats.get("coins", coins)
	high_score = player_stats.get("high_score", high_score)
	upgrades = player_stats.get("upgrades", upgrades)
	skins = player_stats.get("skins", skins)
	lastModified = player_stats.get("lastModified", lastModified)
	_update_last_modified()

func save_name(new_name: String) -> void:
	name = new_name
	_update_last_modified()

func update_coins(new_coins: int) -> void:
	coins = new_coins
	_update_last_modified()

func decrement_coins(decrement: int) -> void:
	update_coins(coins - decrement)
	_update_last_modified()

func update_high_score(new_high_score: float) -> void:
	high_score = max(high_score, new_high_score)
	_update_last_modified()

## upgrades
func get_upgrades() -> Dictionary:
	return upgrades

func upgrade_stat(upgrade: UpgradeResource) -> String:
	var player_upgrade = upgrades.get(upgrade.name)
	
	if not player_upgrade:
		if coins < upgrade.base_price:
			return "Not enough coins"
		decrement_coins(upgrade.base_price)
		upgrades[upgrade.name] = {
			"level": 2,
		}
		return ""
	
	var cost = upgrade.base_price * upgrade.price_per_level_multiplier * player_upgrade.level
	
	if coins < cost:
		return "Not enough coins"

	if player_upgrade.level >= upgrade.max_level:
		printerr("Upgrade %s is already at max level" % upgrade.name)
		return "Max level upgrade"
	
	decrement_coins(cost)
	upgrades[upgrade.name]["level"] += 1
	_update_last_modified()
	save_to_database()
	return ""

func save_to_database() -> void:
	var final_dict = self.to_dict().duplicate()
	final_dict.erase("lastModified")
	final_dict.erase("device_id")
	if not PlayerApi.update_user_success.is_connected(_on_update_user_success):
		PlayerApi.update_user_success.connect(_on_update_user_success)
	PlayerApi.update_user(final_dict)

func _on_update_user_success(result: Dictionary) -> void:
	print_debug("Update user success: %s" % result)

func find_upgrade(upgrade_name: String) -> Dictionary:
	for upgrade in upgrades:
		if upgrade == upgrade_name:
			return upgrades[upgrade]
	return {}
