extends Control
class_name UITextController

@export var game_status_label: Control
@export var game_stats_label: Label
@export var game_reason_label: Control
var displayed_coins := 0
var displayed_score := 0
var animating = false
var score_collected := Game.calculate_score()
var coins_collected :=  Game.calculate_coins()
func update_ui_text(state: Utils.UIStateType, reason: Utils.GameOverReason) -> void:
	match state:
		Utils.UIStateType.PauseMenu:
			game_status_label.text = "PAUSED MENU"
		Utils.UIStateType.GameOver:
			game_status_label.text = "GAME OVER"
			match reason:
				Utils.GameOverReason.OutOfBounds:
					game_reason_label.text = "Player left behind"
				Utils.GameOverReason.Fell:
					game_reason_label.text = "Player fell out of the world"
				Utils.GameOverReason.OutOfEnergy:
					game_reason_label.text = "Player ran out of energy"
			
			var energy = Game.energy
			#var coins_collected := Game.calculate_coins()
			var score := Game.calculate_score()
			var distance := Game.distance_traveled
			var trash := Game.accumulated_trash
			animating = true
			#var text = ""
			#if distance >= 1000:
				#distance = round(distance / 1000.0 * 100) / 100.0
				#text += "Distance Traveled: %s km\n" % distance
			#else:
				#distance = round(distance)
				#text += "Distance Traveled: %d m\n" % distance
				#
			#text += "Trash Collected: %d\n " % trash 
		#
			#if energy > 0:
				#text += "Energy left With: %d\n" % energy
			#
			#text += "badges Gained:     %d\n Overall Score: %.f\n" % [coins_collected, score]
			#text += ""
			#game_stats_label.text = text

func _process(delta: float) -> void:
		if animating:
			await $"..".trans_player.animation_finished	
			while displayed_coins < coins_collected:
				displayed_coins += 1
				print(displayed_coins)
				update_game_stats()
				await get_tree().create_timer(0.05).timeout
				
func update_game_stats() -> void:
	print("testt")
	var text = "Badges Gained: %d\nOverall Score: %d\n" % [displayed_coins, displayed_score]
	game_stats_label.text = text
