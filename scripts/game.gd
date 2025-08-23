extends Node

signal energy_changed(value: int)

var energy = 0
var max_energy = 100

signal trash_collected

var collected_biodegradable = 0
var collected_recyclable = 0
var collected_toxic_waste = 0

func add_energy(energy_bar: EnergyBar, amount: float) -> void:
	var energy_value = energy_bar.value
	energy_value = clamp(energy_value + amount, 0, 100)
	energy_bar.value = lerp(energy_bar.value, energy_value, 1)
