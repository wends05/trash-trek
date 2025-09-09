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
signal run_finished(score: float, coins: int, reason: Utils.GameOverReason)

var collected_biodegradable = 0
var collected_recyclable = 0
var collected_toxic_waste = 0

var accumulated_energy = 0

var is_game_over: bool = false
var is_game_pause: bool = false

var trash_bin_countdown = randi_range(2, 4)

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
	var final_energy_increase = min(amount, MAX_ENERGY - energy)
	energy += final_energy_increase
	energy_changed.emit(energy)
	accumulated_energy += amount

func decrease_energy(amount: float) -> void:
	var final_energy_decrease = max(0, energy - amount)
	energy = final_energy_decrease
	energy_changed.emit(energy)
	accumulated_energy -= amount	

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
	add_energy(1)

func calculate_score() -> float:
	return accumulated_energy + elapsed_time

func calculate_coins() -> float:

	# Example coin formula (distinct from score):
	# - Survival time: 1 coin per 5s
	# - Energy efficiency: 1 coin per 10 accumulated energy
	# - Trash bonuses: R=2, B=1, T=3 each
	# - Small combo bonus every 10 total items
	
	var time_coins = int(elapsed_time / 5.0)
	var energy_coins = int(max(0, accumulated_energy) / 10.0)
	var trash_total = collected_recyclable + collected_biodegradable + collected_toxic_waste
	var trash_coins = collected_recyclable * 2 + collected_biodegradable * 1 + collected_toxic_waste * 3
	var combo_bonus = int(trash_total / 10)
	return max(0, time_coins + energy_coins + trash_coins + combo_bonus)

func on_game_over(reason: Utils.GameOverReason) -> void:
	if is_game_over:
		return
	is_game_over = true
	update_game_state.emit(Utils.GameStateType.Pause)
	update_ui_state.emit(Utils.UIStateType.GameOver, reason)
	var final_score = calculate_score()
	var awarded_coins = calculate_coins()
	run_finished.emit(final_score, awarded_coins, reason)

func reset_stats():
	collected_recyclable = 0
	collected_biodegradable = 0
	collected_toxic_waste = 0
	energy = MAX_ENERGY
	elapsed_time = 0.0
	accumulated_energy = 0
	trash_bin_countdown = randi_range(2, 4)
	updated_stats.emit()
	energy_changed.emit(int(energy))
	time_changed.emit(elapsed_time)
	energy_timer.start()
	is_game_over = false

func select_trash_type(type: Utils.TrashType):
	selected_trash_type = type
	changed_trash_type.emit(type)


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

func decrease_trash_bin_countdown():
	trash_bin_countdown -= 1
