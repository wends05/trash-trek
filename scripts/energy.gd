extends ProgressBar

class_name EnergyBar

func _ready() -> void:
	Game.energy_changed.connect(change_energy_value)

func change_energy_value(energy: int):
	value = energy
