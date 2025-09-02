extends Label

func _ready() -> void:
	Game.time_changed.connect(update_time)

func update_time(time: float) -> void:
	var minutes = int(time) / 60
	var seconds = int(time) % 60
	text = "%02d:%02d" % [minutes, seconds]
