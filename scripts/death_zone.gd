extends Area2D

func _on_death_zone_left_body_entered(body: Node2D) -> void:
	if body is Player:
		Game.is_game_over = true
		Game.update_game_state.emit(Utils.GameStateType.Pause)
		Game.update_ui_state.emit(Utils.UIStateType.GameOver, Utils.GameOverReason.OutOfBounds)

func _on_death_zone_below_body_entered(body: Node2D) -> void:
	if body is Player:
		Game.is_game_over = true
		Game.update_game_state.emit(Utils.GameStateType.Pause)
		Game.update_ui_state.emit(Utils.UIStateType.GameOver, Utils.GameOverReason.Fell)
