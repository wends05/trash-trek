extends Area2D

class_name GroundArea

@export var ground_y_above: int
@export var ground_y_below: int
@export var is_gap: bool = false

func _ready() -> void:
	pass

func bring_trash_above(trash: Node2D, offset: int):
	if trash is TrashBin:
		trash.position.y = ground_y_below - offset
		return
	trash.position.y = [ground_y_above, ground_y_below].pick_random() if not is_gap else ground_y_above
