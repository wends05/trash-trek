extends TextureProgressBar

class_name EnergyBar

var _tween: Tween

func _ready() -> void:
	max_value = Game.MAX_ENERGY
	Game.energy_changed.connect(change_energy_value)
	change_energy_value(Game.energy)

	
	
func change_energy_value(energy: int):
	zero_energy(energy)
	# Kill previous tween if still running
	if _tween and _tween.is_valid():
		_tween.kill()
	# Create a new tween to smoothly animate the bar value
	_tween = create_tween()
	_tween.tween_property(self, "value", float(energy), 0.25)
	_tween.set_trans(Tween.TRANS_QUAD)
	_tween.set_ease(Tween.EASE_OUT)

func zero_energy(energy: int):
	if energy == 0:
		Game.is_game_over = true
		Game.update_game_state.emit(Utils.GameStateType.Pause)
		Game.update_ui_state.emit( Utils.UIStateType.GameOver, Utils.GameOverReason.OutOfEnergy)
