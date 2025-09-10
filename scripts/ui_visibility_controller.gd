extends Control
class_name UIVisibilityController

@export var pause_button: Control
@export var game_status_label: Control
@export var game_menu: Control
@export var game_stats: Label
@onready var brush_stroke: Sprite2D = $"../GameMenu/BrushStroke"
@onready var trans_player = $"../GameMenu/TransPlayer"
@onready var ui: UI = $".."

func _ready() -> void:
	toggle_nodes([game_menu, game_status_label, game_stats])

func update_ui_visibility(state: Utils.UIStateType) -> void:
	match state:
		Utils.UIStateType.PauseMenu:
			toggle_nodes([
				pause_button, 
				game_status_label, 
				game_menu, 
				game_menu.retry_button,
			])
			brush_stroke.visible = false
		Utils.UIStateType.GameOver:
			toggle_nodes([
				pause_button, 
				game_status_label, 
				game_menu, 
				game_menu.resume_button, 
				game_menu.restart_button,
				game_stats
			])
			brush_stroke.visible = true
			ui.game_menu_animation(true, "retry")
			ui.enable_buttons([game_menu.quit_button, game_menu.menu_button, game_menu.retry_button])
			Game.is_game_over = true
		

func toggle_nodes(nodes: Array[Control]) -> void:
	for node in nodes:
		node.visible = !node.visible
		if node is Button:
			node.mouse_filter = Control.MOUSE_FILTER_PASS if node.visible else Control.MOUSE_FILTER_IGNORE
