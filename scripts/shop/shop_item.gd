extends Control

class_name ShopItem

@export var name_label: Label

var cost: int
@export var upgrade_button: BaseButton
@export var upgrade_button_label: Label

signal coin_upgrade_error(message: String)


func _ready() -> void:
	upgrade_button.pressed.connect(_on_upgrade_button_pressed)

	_ready_item()
	_display_item()

func _ready_item():
	printerr("Ready item not implemented")

func _display_item():
	_display_buy_button()
	_display_item_stats()

func _display_buy_button():
	upgrade_button.disabled = false
	upgrade_button_label.text = "%d" % cost


func _display_item_stats():
	printerr("Display stats not implemented")

func _on_upgrade_button_pressed() -> void:
	printerr("Upgrade button pressed for ShopItem. Function not implemented")

func _check_api_error(err: String):
	if err:
		coin_upgrade_error.emit("%s: %s" % [name_label.text, err])
	else:
		_display_item()
