extends Label

func _ready() -> void:
	Game.time_changed.connect(update_distance)

func update_distance(meters: float) -> void:
	if meters >= 1000:
		var km = round(meters / 1000.0)
		text = str(km) + " km"
	else:
		text = str(int(round(meters))) + " m"
	Game.distance_traveled = int(round(meters))
