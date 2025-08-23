extends Control

class_name UI

@onready var temp_trash_count_display: Node = get_node(NodePath("TempTrashCount"))
@onready var pause_button: Node = get_node(NodePath("PauseButton"))

func _ready() -> void:
	Game.updated_stats.connect(update_trash_counts)
	
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
	paused_game()

func paused_game():
	get_tree().paused = !get_tree().paused
