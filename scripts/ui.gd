extends Control
class_name UI

@onready var trash_count_display: Label = $TrashCount
@onready var ui_text_controller: UITextController = $UITextController
@onready var ui_visibility_controller: UIVisibilityController = $UIVisibilityController
@onready var pause_animation = $PauseButton/PauseAnimate
@onready var trans_player: AnimationPlayer = $GameMenu/TransPlayer
@onready var text_player: AnimationPlayer = $TextPlayer
@onready var hover_player: AnimationPlayer = $GameMenu/HoverPlayer
@onready var bg_player: AnimationPlayer = $"../BackgroundPlayer"
@export var game_menu: Control

@onready var bg = $"../Background/Background"
@onready var mg = $"../Background/Midground"
@onready var fg = $"../Background/Foreground"

var my_buttons: Array

func _ready() -> void:
	my_buttons = [
		game_menu.restart_button,
		game_menu.resume_button,
		game_menu.resume_button,
		game_menu.quit_button,
		game_menu.menu_button,
	]
	disable_buttons(my_buttons)
	
	Game.updated_stats.connect(update_trash_counts)
	Game.update_ui_state.connect(update_ui_state)
	Game.update_game_state.connect(update_game_state)
	
	
	$%BiodegradableButton.connect("pressed", _on_group_pressed.bind(Utils.TrashType.Biodegradable))
	$%RecyclableButton.connect("pressed", _on_group_pressed.bind(Utils.TrashType.Recyclable))
	$%ToxicWasteButton.connect("pressed", _on_group_pressed.bind(Utils.TrashType.ToxicWaste))
	
	update_trash_counts()
	toggle_button_pressed(Game.selected_trash_type)

func _process(_delta: float) -> void:
	toggle_pause()
			
func _input(event: InputEvent) -> void:
	if event.is_pressed():
		if event.is_action_pressed("recyclable"):
			toggle_button_pressed(Utils.TrashType.Recyclable)
		elif event.is_action_pressed("biodegradable"):
			toggle_button_pressed(Utils.TrashType.Biodegradable)
		elif event.is_action_pressed("toxic_waste"):
			toggle_button_pressed(Utils.TrashType.ToxicWaste)

func toggle_button_pressed(type: Utils.TrashType):
	match type:
		Utils.TrashType.Recyclable:
			$%RecyclableButton.button_pressed = true
			_on_group_pressed(Utils.TrashType.Recyclable)
		Utils.TrashType.Biodegradable:
			$%BiodegradableButton.button_pressed = true
			_on_group_pressed(Utils.TrashType.Biodegradable)
		Utils.TrashType.ToxicWaste:
			$%ToxicWasteButton.button_pressed = true
			_on_group_pressed(Utils.TrashType.ToxicWaste)

func update_trash_counts():
	trash_count_display.text = \
	"%s              %s              %s
	" % [
		Game.collected_recyclable,
		Game.collected_biodegradable,
		Game.collected_toxic_waste
	]

func toggle_pause():
	if Input.is_action_just_pressed("esc") and not Game.is_game_over:
		Game.is_game_pause = !Game.is_game_pause
		if Game.is_game_pause:
			enable_buttons(my_buttons)
			update_ui_state(Utils.UIStateType.PauseMenu)
			game_menu_animation(true)
			update_game_state(Utils.GameStateType.Pause)
		else:
			disable_buttons(my_buttons)
			game_menu_animation(false)
			await text_player.animation_finished
			update_game_state(Utils.GameStateType.Play)
			update_ui_state(Utils.UIStateType.PauseMenu)
			
func _on_pause_button_pressed() -> void:
	if Game.is_game_over:
		return
	Game.is_game_pause = true
	enable_buttons(my_buttons)
	update_ui_state(Utils.UIStateType.PauseMenu)
	game_menu_animation(true)
	update_game_state(Utils.GameStateType.Pause)

func _on_pause_button_mouse_entered() -> void:
	pause_animation.play("pause_hover")

func _on_pause_button_mouse_exited() -> void:
	pause_animation.play_backwards("pause_hover")

func update_ui_state(state: Utils.UIStateType, reason: Utils.GameOverReason = Utils.GameOverReason.None) -> void:
	ui_visibility_controller.update_ui_visibility(state)
	ui_text_controller.update_ui_text(state, reason)
	
func update_game_state(state: Utils.GameStateType) -> void:
	match state:
		Utils.GameStateType.Pause:
			if Game.is_game_over:
				Engine.time_scale = 0.3
				var timer = get_tree().create_timer(0.3)
				timer.timeout.connect(func():
					Engine.time_scale = 1
					$GameMenu/BrushStroke.visible = true
					game_menu_animation(true, "retry")
					await trans_player.animation_finished
					enable_buttons([game_menu.quit_button, game_menu.menu_button, game_menu.retry_button])
					get_tree().paused = true
				)
					
			else:
				get_tree().paused = true
		Utils.GameStateType.Play:
			get_tree().paused = false

func disable_buttons(buttons: Array):
	for button in buttons:
		button.mouse_filter = Control.MOUSE_FILTER_IGNORE
		
func enable_buttons(buttons: Array):
	for button in buttons:
		button.mouse_filter = Control.MOUSE_FILTER_PASS

func _on_group_pressed(type: Utils.TrashType):
	print_debug("Pressed, ", type)
	Game.select_trash_type(type)
	
func game_menu_animation(forward: bool, mode = null) -> void:
	if forward:
		Utils.anim_player(trans_player, "fade_in")
		Utils.anim_player(text_player, "GameStatus")
		if !Game.is_game_over:
			Utils.anim_player(bg_player, "bg_fade_in")
		if mode == "retry":
			Utils.anim_player(hover_player, "retry_hover")
		else:
			Utils.anim_player(hover_player, "resume_hover")
	else:
		bg_player.play_backwards("bg_fade_in")
		trans_player.play_backwards("fade_in")
		text_player.play_backwards("GameStatus")
	
	await text_player.animation_finished
