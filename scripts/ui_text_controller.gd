extends Control

class_name UITextController

@export var ui: UI

@export var game_status_label: Control
@export var game_stats_label: RichTextLabel
@export var game_reason_label: Control
const SFX_FILL = preload("res://audios/count.ogg")
const SFX_SUCCESS = preload("res://audios/success.ogg")

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

func update_ui_text_state(state: Utils.UIStateType) -> void:
	match state:
		Utils.UIStateType.PauseMenu:
			game_status_label.text = "PAUSED MENU"
		Utils.UIStateType.GameOver:
			game_status_label.text = "GAME OVER"
			

func update_ui_text_game_over(reason: Utils.GameOverReason) -> void:
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
		await $"..".text_player.animation_finished
		var timer = get_tree().create_timer(0.3)
		timer.timeout.connect(func():
			animating = true
			animating_distance = false
			animating_trash = true
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
		
		if animating_trash:
			if trash_collected <= 0:
				displayed_trash = 0
				animating_trash = false
				await_delay_then_start("distance")
			elif displayed_trash < trash_collected:
				displayed_trash += 1
				AudioManager.play_sfx(SFX_FILL, -3)
				updated = true
			else:
				animating_trash = false
				await_delay_then_start("distance")
		
		elif animating_distance:
			if displayed_distance < distance_collected:
				displayed_distance += 1
				AudioManager.play_sfx(SFX_FILL, -3)
				updated = true
			else:
				animating_distance = false
				await_delay_then_start("coins")
		
		elif animating_coins:
			if displayed_coins < coins_collected:
				displayed_coins += 1
				AudioManager.play_sfx(SFX_FILL, -3)
				updated = true
			else:
				animating_coins = false
				await_delay_then_start("score")

		
		elif animating_score:
			if displayed_score < score_collected:
				AudioManager.play_sfx(SFX_FILL, -3)
				displayed_score += 1
				updated = true
			else:
				AudioManager.play_sfx(SFX_SUCCESS, -10)
				animating_score = false
				animating = false

		if updated:
			update_game_stats()


func update_game_stats() -> void:
	var text = "[center]"
	text += "[font_size=30]Overall Score:[/font_size] \n[color=white][font_size=50]%d[/font_size][/color]\n" % displayed_score

	if trash_collected <= 0:
		text += "[img=40x50]res://assets/buttons/button1.png[/img] [font_size=20]0[/font_size]  "
	else:
		text += "[img=40x50]res://assets/buttons/button1.png[/img] [font_size=20]%d[/font_size]  " % displayed_trash

	if displayed_distance >= 1000:
		var km = float(displayed_distance) / 1000.0
		text += "  [img=40x50]res://assets/menu/player_run.png[/img] [font_size=20]%.2f[/font_size] km " % km
	else:
		text += "  [img=40x50]res://assets/menu/player_run.png[/img] [font_size=20]%d m[/font_size] " % displayed_distance

	text += "[img=50x30]res://assets/menu/badge.png[/img][font_size=20]%d[/font_size] " % displayed_coins
	#if animating_score:
		#text += "Overall Score: %d\n" % displayed_score
	#if animating_trash or animating_distance or animating_coins or animating_score:
		#if trash_collected <= 0:
			#text += "[img=40x50]res://assets/buttons/button1.png[/img] 0  \n"
		#else:
			#text += "[img=40x50]res://assets/buttons/button1.png[/img] %d  \n" % displayed_trash
	#if animating_distance or animating_coins or animating_score:
		#if distance_collected >= 1000:
			#var km = float(distance_collected) / 1000.0
			#text += "[img=40x50]res://assets/menu/player_run.png[/img] %.2f km\n" % km
		#else:
			#text += "[img=50x50]res://assets/menu/player_run.png[/img] %d m\n" % distance_collected
	#if animating_coins or animating_score:
		#text += " [img=50x25]res://assets/menu/badge.png[/img]%d    " % displayed_coins
	text += "[/center]"
	game_stats_label.text = text
		
func await_delay_then_start(next: String) -> void:
	await get_tree().create_timer(0.6).timeout
	match next:
		"distance":
			animating_distance = true
		"coins":
			animating_coins = true
		"score":
			$"../UIVisibilityController".toggle_nodes(ui.game_over_buttons)
			ui.enable_buttons(ui.game_over_buttons)
			animating_score = true
