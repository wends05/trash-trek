extends Control
class_name UITextController

@export var game_status_label: Control
@export var game_reason_label: Control

func update_ui_text(state: Utils.UIStateType, reason: Utils.GameOverReason) -> void:
	match state:
		Utils.UIStateType.PauseMenu:
			game_status_label.text = "Paused Menu"
		Utils.UIStateType.GameOver:
			game_status_label.text = "Game Over"
			match reason:
				Utils.GameOverReason.OutOfBounds:
					game_reason_label.text = "Player left behind"
				Utils.GameOverReason.Fell:
					game_reason_label.text = "Player fell out of the world"
				Utils.GameOverReason.OutOfEnergy:
					game_reason_label.text = "Player ran out of energy"
