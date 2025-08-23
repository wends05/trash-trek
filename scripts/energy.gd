extends ProgressBar

class_name EnergyBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Game.energy_changed.connect(change_energy_value)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func change_energy_value(energy: int):
	value = energy
