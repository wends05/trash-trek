extends Control
class_name UIVisibilityController

@export var pause_button: Control
@export var game_status_label: Control
@export var game_menu: Control
@export var game_stats: RichTextLabel
@onready var brush_stroke: Sprite2D = $"../GameMenu/BrushStroke"
@onready var trans_player = $"../GameMenu/TransPlayer"
@onready var ui: UI = $".."

func _ready() -> void:
	brush_stroke.visible = false
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
		Utils.UIStateType.GameOver:
			var timer = get_tree().create_timer(0.3)
			timer.timeout.connect(func():
				toggle_nodes([
					pause_button, 
					game_status_label, 
					game_menu, 
					game_menu.resume_button, 
					game_menu.restart_button,
					game_stats
				])
			)
			$"../EnergyBar".visible = false
			$"../Button Labels".visible = false
			$"../Buttons".visible = false
			$"../PauseButton".visible = false
			$"../TrashCount".visible = false
			$"../PauseButton".visible = false
			$"../Distance".visible = false
			toggle_nodes(ui.game_over_buttons)
			ui.bg_player.play("bg_fade_in")

func toggle_nodes(nodes: Array[Control]) -> void:
	for node in nodes:
		node.visible = !node.visible
		if node is Button:
			node.mouse_filter = Control.MOUSE_FILTER_PASS if node.visible else Control.MOUSE_FILTER_IGNORE
