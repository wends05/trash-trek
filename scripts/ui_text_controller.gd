extends Control
class_name UITextController

@export var game_status_label: Control
@export var game_stats_label: Label
@export var game_reason_label: Control

var displayed_distance := 0
var displayed_trash := 0
var displayed_coins := 0
var displayed_score := 0


var animating = false
var animating_distance := false
var animating_trash := false
var animating_coins := false
var animating_score := false
var distance_collected
var trash_collected
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
			distance_collected = int(Game.distance_traveled)
			trash_collected = int(Game.accumulated_trash)
			
			displayed_coins = 0
			displayed_score = 0
			await	$"..".text_player.animation_finished
			var timer = get_tree().create_timer(0.3)
			timer.timeout.connect(func():
				animating = true
				animating_distance = true 
				animating_trash = false
				animating_coins = false
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

		if animating_distance:	
			if displayed_distance < distance_collected:
				displayed_distance += 1
				updated = true
			else:
				animating_distance = false
				await_delay_then_start("trash")
		
		elif animating_trash:
			if displayed_trash < trash_collected:
				displayed_trash += 1
				updated = true
			else:
				animating_trash = false
				await_delay_then_start("coins")
		
		elif animating_coins:
			if displayed_coins < coins_collected:
				displayed_coins += 1
				updated = true
			else:
				animating_coins = false
				await_delay_then_start("score")

		
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
	if animating_distance:
		if distance_collected >= 1000:
			var km = float(distance_collected) / 1000.0
			game_stats_label.text = "Distance Traveled: \n%.2f km" % km
		else:
			game_stats_label.text = "Distance Traveled: \n%d m" % distance_collected
	elif animating_trash:
		game_stats_label.text = "Trash Collected: \n%d" % trash_collected
	elif animating_coins:
		$"../TextPlayer".play("reveal_badge")
		game_stats_label.text = "Badges Gained: \n%d" % displayed_coins
	elif animating_score:
		game_stats_label.text = "Overall Score: \n%d" % displayed_score

func await_delay_then_start(next: String) -> void:
	await get_tree().create_timer(0.7).timeout
	match next:
		"trash":
			animating_trash = true
		"coins":
			$"../TextPlayer".play("reveal_badge") 
			animating_coins = true
		"score":
			$"../TextPlayer".play_backwards("reveal_badge") 
			animating_score = true
