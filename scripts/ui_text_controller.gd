extends Control
class_name UITextController

@export var game_status_label: Control
@export var game_stats_label: Label
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
			
			var energy = Game.energy
			var coins_collected := Game.calculate_coins()
			var score := Game.calculate_score()
			
			var text = ""
			if energy > 0:
				text += "Energy: %d\n" % energy
			
			text += "Coins Gained: %d\nScore: %.2f\n" % [coins_collected, score]
			print_debug(text)
			game_stats_label.text = text
