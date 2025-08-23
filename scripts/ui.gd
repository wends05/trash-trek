extends Control

class_name UI

@onready var temp_trash_count_display: Node = get_node(NodePath("TempTrashCount"))
@onready var pause_button: Node = get_node(NodePath("PauseButton"))
@onready var pause_menu: Node = get_node(NodePath("PauseMenu"))

func _ready() -> void:
	Game.updated_stats.connect(update_trash_counts)
	Game.update_ui_state.connect(update_ui_state)
	Game.update_game_state.connect(toggle_game_state)
	toggle_nodes([pause_menu])
	
func update_trash_counts():
	temp_trash_count_display.text =\
	"rec: %s
	bio: %s
	tox: %s
	" % [
		Game.collected_recyclable,
		Game.collected_biodegradable,
		Game.collected_toxic_waste
	]

func _on_pause_button_pressed() -> void:
	update_ui_state()
	toggle_game_state(Utils.GameStateType.Pause)

func update_ui_state(state: Utils.UIStateType = Utils.UIStateType.Pause) -> void:
	match state:
		Utils.UIStateType.Pause:
			toggle_nodes([pause_button, pause_menu])

func toggle_nodes(nodes: Array[Control]) -> void:
	for node in nodes:
		node.visible = !node.visible

func toggle_game_state(state: Utils.GameStateType) -> void:
	match state:
		Utils.GameStateType.Pause:
			get_tree().paused = true
		Utils.GameStateType.Play:
			get_tree().paused = false
	
