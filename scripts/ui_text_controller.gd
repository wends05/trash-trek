extends Control
class_name UITextController

@export var game_status_label: Control
@export var game_stats_label: Label
@export var game_reason_label: Control
var displayed_coins := 0
var displayed_score := 0
var animating = false
var animating_coins := false
var animating_score := false
var score_collected
var coins_collected

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
			
			#var energy = Game.energy
			coins_collected = Game.calculate_coins()
			score_collected = Game.calculate_score()
			
			var score := Game.calculate_score()
			var distance := Game.distance_traveled
			var trash := Game.accumulated_trash
			
			displayed_coins = 0
			displayed_score = 0
			await	$"..".text_player.animation_finished
			var timer = get_tree().create_timer(0.3)
			timer.timeout.connect(func():
				animating = true
				animating_coins = true
				animating_score = false
			)
		
			#var text = ""
			#if distance >= 1000:
				#distance = round(distance / 1000.0 * 100) / 100.0
				#text += "Distance Traveled: %s km\n" % distance
			#else:
				#distance = round(distance)
				#text += "Distance Traveled: %d m\n" % distance
				#
			#text += "Trash Collected: %d\n " % trash 
		
			#if energy > 0:
				#text += "Energy left With: %d\n" % energy
			#
			#text += "badges Gained:    %d\n Overall Score: %.f\n" % [coins_collected, score]
			#text += ""
			#game_stats_label.text = text
			
			

func _process(delta: float) -> void:
	if animating:
		var updated := false

		# Step 1: Animate coins first
		if animating_coins:
			if displayed_coins < coins_collected:
				displayed_coins += 1
				updated = true
			else:
				animating_coins = false
				await_delay_then_start_score()

		# Step 2: Animate score after coins
		elif animating_score:
			if displayed_score < score_collected:
				displayed_score += 1
				updated = true
			else:
				animating_score = false
				animating = false

		if updated:
			update_game_stats()


func update_game_stats() -> void:
	var text = ""
	if animating_coins:
		game_stats_label.text = "Badges Gained: %d" % displayed_coins
	elif animating_score:
		game_stats_label.text = "Overall Score: %d" % displayed_score

func await_delay_then_start_score() -> void:
	await get_tree().create_timer(0.5).timeout 
	animating_score = true
