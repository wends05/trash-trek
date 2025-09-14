extends Node

var base_max_energy = 100.0
var max_energy = base_max_energy
var energy = max_energy

var elapsed_time: float = 0.0
var distance_traveled: float = 0.0
var base_wait_time: float = 18
var difficulty_step: float = 12

signal trash_collected(type: Utils.TrashType)
signal energy_changed(value: int)
signal updated_stats
signal time_changed(time: float)

signal update_ui_state(type: Utils.UIStateType)
signal game_over(reason: Utils.GameOverReason)
signal update_game_state(type: Utils.GameStateType)

var collected_biodegradable = 0
var collected_recyclable = 0
var collected_toxic_waste = 0

var accumulated_trash: int = 0

var accumulated_energy = 0

var is_game_over: bool = false
var is_game_pause: bool = false

var trash_bin_countdown = randi_range(2, 4)

var selected_trash_type: Utils.TrashType
signal changed_trash_type(type: Utils.TrashType)

var energy_timer: Timer
var player_stats_resource: PlayerStatsResource = PlayerStatsResource.get_instance()

func _process(delta: float) -> void:
	if not is_game_pause:
		elapsed_time += delta
		
## In built functions
func _ready() -> void:
	trash_collected.connect(update_trash_count)

	print("Final Max energy: %s" % max_energy)
	energy_timer = Timer.new()
	energy_timer.wait_time = 1.0
	energy_timer.one_shot = false
	energy_timer.autostart = true
	add_child(energy_timer)

	energy_timer.timeout.connect(_on_energy_timer_timeout)

	max_energy = calculate_value("ecapacity", max_energy)
	update_ui_state.connect(_on_update_ui_state)
	game_over.connect(on_game_over)
	

	set_process(true)


func _on_energy_timer_timeout() -> void:
	var difficulty_level = int(elapsed_time / difficulty_step)
	energy_timer.wait_time = max(6, base_wait_time - difficulty_level)
	var energy_decrease = min(1 + difficulty_level, 9)
	decrease_energy(energy_decrease)

## Energy related
func _increase_energy(amount: float) -> void:
	var final_energy_increase = min(amount, max_energy - energy)
	energy += final_energy_increase
	energy_changed.emit(energy)
	accumulated_energy += amount

func decrease_energy(amount: float) -> void:
	var final_energy_decrease = max(0, energy - amount)
	energy = final_energy_decrease
	energy_changed.emit(energy)


## Trash related
func update_trash_count(type: Utils.TrashType):
	accumulated_trash += 1
	var base_energy_increment = calculate_value("egain", 0)
	if type == Utils.TrashType.Recyclable:
		collected_recyclable += 1
		_increase_energy(base_energy_increment + 2)
	elif type == Utils.TrashType.Biodegradable:
		collected_biodegradable += 1
		_increase_energy(base_energy_increment + 1)
	elif type == Utils.TrashType.ToxicWaste:
		collected_toxic_waste += 1
		_increase_energy(base_energy_increment + 3)

	updated_stats.emit()

func select_trash_type(type: Utils.TrashType):
	selected_trash_type = type
	changed_trash_type.emit(type)


## Trashbin related
func throw_trash(type: Utils.TrashType, trash_amount: int):
	_decrease_trash_count(type, trash_amount)
	_increase_energy(trash_amount * 2)

func get_trash_count(type: Utils.TrashType):
	match type:
		Utils.TrashType.Recyclable:
			return collected_recyclable
		Utils.TrashType.Biodegradable:
			return collected_biodegradable
		Utils.TrashType.ToxicWaste:
			return collected_toxic_waste

func _decrease_trash_count(type: Utils.TrashType, amount: int):
	match type:
		Utils.TrashType.Recyclable:
			collected_recyclable -= amount
		Utils.TrashType.Biodegradable:
			collected_biodegradable -= amount
		Utils.TrashType.ToxicWaste:
			collected_toxic_waste -= amount
	updated_stats.emit()

func reset_trash_bin_countdown():
	trash_bin_countdown = randi_range(2, 4)

func decrease_trash_bin_countdown():
	trash_bin_countdown -= 1


## Monster related
func player_hurt(amount: int):
	var base_energy_decrease = calculate_value("immunity", 0)
	decrease_energy(amount - base_energy_decrease)


## Score related
func calculate_score() -> int:
	return accumulated_trash + accumulated_energy + floor(elapsed_time)

func calculate_coins() -> float:
	var time_coins = int(elapsed_time / 5.0)
	var energy_coins = int(max(0, accumulated_energy) / 10.0)
	var trash_coins = collected_recyclable * 2 + collected_biodegradable * 1 + collected_toxic_waste * 3
	return max(0, time_coins + energy_coins + trash_coins)

func _on_update_ui_state(type: Utils.UIStateType) -> void:
	if type == Utils.UIStateType.GameOver:
		print_debug("NAG GAME OVER")


func on_game_over(reason: Utils.GameOverReason) -> void:
	var final_score = calculate_score()
	var awarded_coins = calculate_coins()
	update_player_stats(final_score, awarded_coins, reason)

func reset_stats():
	select_trash_type(Utils.TrashType.Recyclable)
	collected_recyclable = 0
	collected_biodegradable = 0
	collected_toxic_waste = 0
	accumulated_trash = 0
	max_energy = calculate_value("ecapacity", base_max_energy)
	energy = max_energy
	elapsed_time = 0.0
	accumulated_energy = 0
	trash_bin_countdown = randi_range(2, 4)
	updated_stats.emit()
	energy_changed.emit(int(energy))
	time_changed.emit(elapsed_time)
	energy_timer.start()
	is_game_over = false

func update_player_stats(final_score: float, coins_collected: int, _reason: Utils.GameOverReason) -> void:
	print("Attempting to update player")
	player_stats_resource.update_coins(player_stats_resource.coins + coins_collected)
	player_stats_resource.update_high_score(final_score)
	player_stats_resource.save_to_database()
	
## Upgrade related
func calculate_value(res_file_name: String, value: float):
	var upgrade_resource: UpgradeResource = load("res://resources/shop/upgrades/%s.tres" % res_file_name)

	var resource_name = upgrade_resource.name
	var upgrade = player_stats_resource.find_upgrade(resource_name)
	
	if not upgrade:
		return value
	
	if not upgrade_resource:
		print_debug("Upgrade resource not found: %s" % upgrade)
		return value
	
	return value + upgrade_resource.stat_increase_per_level * upgrade.level
