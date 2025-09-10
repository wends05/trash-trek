extends Control
var Username = "string"

func _on_reset_pressed() -> void:
	Utils.save_coins(0)
	Username = null
