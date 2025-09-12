extends Label

func _ready() -> void:
	Game.time_changed.connect(update_distance)

func update_distance(meters: float) -> void:
	text = str(meters) + " m"
