extends Control
class_name UI

@onready var trash_count_display: Label = $TrashCount
@onready var ui_text_controller: UITextController = $UITextController
@onready var ui_visibility_controller: UIVisibilityController = $UIVisibilityController
@onready var pause_animation = $PauseButton/PauseAnimate

func _ready() -> void:
	Game.updated_stats.connect(update_trash_counts)
	Game.update_ui_state.connect(update_ui_state)
	Game.update_game_state.connect(update_game_state)

	
	$%BiodegradableButton.connect("pressed", _on_group_pressed.bind(Utils.TrashType.Biodegradable))
	$%RecyclableButton.connect("pressed", _on_group_pressed.bind(Utils.TrashType.Recyclable))
	$%ToxicWasteButton.connect("pressed", _on_group_pressed.bind(Utils.TrashType.ToxicWaste))
	
	update_trash_counts()
	
func _process(delta: float) -> void:
	toggle_pause()
			
func _input(event: InputEvent) -> void:
	if event.is_pressed():
		if event.is_action_pressed("recyclable"):
			$%RecyclableButton.button_pressed = true
			_on_group_pressed(Utils.TrashType.Recyclable)
			return
		if event.is_action_pressed("biodegradable"):
			$%BiodegradableButton.button_pressed = true
			_on_group_pressed(Utils.TrashType.Biodegradable)
			return
		if event.is_action_pressed("toxic_waste"):
			$%ToxicWasteButton.button_pressed = true
			_on_group_pressed(Utils.TrashType.ToxicWaste)
			return

func update_trash_counts():
	trash_count_display.text = \
	"%s                %s                %s
	" % [
		Game.collected_recyclable,
		Game.collected_biodegradable,
		Game.collected_toxic_waste
	]


func toggle_pause():
	if Input.is_action_just_pressed("esc") and not Game.is_game_over:
		Game.is_game_pause = !Game.is_game_pause
		if Game.is_game_pause:
			update_ui_state(Utils.UIStateType.PauseMenu)
			update_game_state(Utils.GameStateType.Pause)
		else:
			update_ui_state(Utils.UIStateType.PauseMenu)
			update_game_state(Utils.GameStateType.Play)
					
#func update_trash_bin_countdown():
	#temp_trash_countdown_display.text = \
	#"Trash Bin Countdown: %s" % Game.trash_bin_countdown

func _on_pause_button_pressed() -> void:
	update_ui_state(Utils.UIStateType.PauseMenu)
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
			get_tree().paused = true
		Utils.GameStateType.Play:
			get_tree().paused = false

func _on_group_pressed(type: Utils.TrashType):
	print_debug("Pressed, ", type)
	Game.select_trash_type(type)
