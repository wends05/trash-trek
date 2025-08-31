extends Node

const MAX_ENERGY = 100.0
var energy = MAX_ENERGY
var elapsed_time: float = 0.0
var base_wait_time: float = 0.5
var base_decrease: float = 0.5
var difficulty_step: float = 10.0

signal trash_collected(type: Utils.TrashType)
signal energy_changed(value: int)
signal updated_stats
signal time_changed(time: float)
signal update_ui_state(type: Utils.UIStateType, reason: Utils.GameOverReason)
signal update_game_state(type: Utils.GameStateType)

var collected_biodegradable = 0
var collected_recyclable = 0
var collected_toxic_waste = 0

var is_game_over: bool = false
var is_game_pause: bool = false

var trash_bin_countdown = randi_range(2, 4)
signal trash_bin_countdown_changed

var selected_trash_type: Utils.TrashType
signal changed_trash_type(type: Utils.TrashType)

var energy_timer: Timer

func _ready() -> void:
	trash_collected.connect(update_trash_count)

	energy_timer = Timer.new()
	energy_timer.wait_time = 1.0
	energy_timer.one_shot = false
	energy_timer.autostart = true
	add_child(energy_timer)
	energy_timer.timeout.connect(_on_energy_timer_timeout)

	set_process(true)

func _process(delta: float) -> void:
	elapsed_time += delta
	time_changed.emit(elapsed_time)

	var difficulty_level = int(elapsed_time / difficulty_step)


	energy_timer.wait_time = 0.5
	base_decrease = 0.1

func add_energy(amount: float) -> void:
	energy += min(amount, MAX_ENERGY - energy)
	energy_changed.emit(energy)

func decrease_energy(amount: float) -> void:
	energy = max(0, energy - amount)
	energy_changed.emit(int(energy))

func _on_energy_timer_timeout() -> void:
	decrease_energy(base_decrease)

func update_trash_count(type: Utils.TrashType):
	if type == Utils.TrashType.Recyclable:
		collected_recyclable += 1
		energy_timer.start()

	elif type == Utils.TrashType.Biodegradable:
		collected_biodegradable += 1
		energy_timer.start()

	elif type == Utils.TrashType.ToxicWaste:
		collected_toxic_waste += 1
		energy_timer.start()

	updated_stats.emit()

func reset_stats():
	collected_recyclable = 0
	collected_biodegradable = 0
	collected_toxic_waste = 0
	energy = MAX_ENERGY
	elapsed_time = 0.0
	updated_stats.emit()
	energy_changed.emit(int(energy))
	time_changed.emit(elapsed_time)
	energy_timer.start()

func select_trash_type(type: Utils.TrashType):
	selected_trash_type = type
	changed_trash_type.emit(type)

func handle_throw_trash(trash_bin: TrashBin):
	if selected_trash_type == trash_bin.type:
		print_debug("Correct Trash, energy_added")
		add_energy(10)
		var percent_decrease = randf_range(0.2, 0.4)
		decrease_trash_count(selected_trash_type, int(collected_recyclable * percent_decrease))

func get_trash_count(type: Utils.TrashType):
	match type:
		Utils.TrashType.Recyclable:
			return collected_recyclable
		Utils.TrashType.Biodegradable:
			return collected_biodegradable
		Utils.TrashType.ToxicWaste:
			return collected_toxic_waste

func decrease_trash_count(type: Utils.TrashType, amount: int):
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
	trash_bin_countdown_changed.emit()

func decrease_trash_bin_countdown():
	trash_bin_countdown -= 1
	trash_bin_countdown_changed.emit()
