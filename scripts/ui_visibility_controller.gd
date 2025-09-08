extends Control
class_name UIVisibilityController

@export var pause_button: Control
@export var game_status_label: Control
@export var game_menu: Control
@export var background_rect: Control
@export var game_stats: Label

func _ready() -> void:
	toggle_nodes([game_menu, game_status_label, game_stats, background_rect])

func update_ui_visibility(state: Utils.UIStateType) -> void:
	match state:
		Utils.UIStateType.PauseMenu:
			toggle_nodes([
				background_rect,
				pause_button, 
				game_status_label, 
				game_menu, 
				game_menu.retry_button
			])
		Utils.UIStateType.GameOver:
			toggle_nodes([
				background_rect,
				pause_button, 
				game_status_label, 
				game_menu, 
				game_menu.resume_button, 
				game_menu.restart_button,
				game_stats
			])
			Game.is_game_over = true

func toggle_nodes(nodes: Array[Control]) -> void:
	for node in nodes:
		node.visible = !node.visible
