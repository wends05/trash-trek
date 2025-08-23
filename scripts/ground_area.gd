extends Area2D

class_name GroundArea

@export var ground_y_above: int
@export var ground_y_below: int
@export var is_gap: bool = false

func _ready() -> void:
	pass

func bring_trash_above(trash: Trash):
	trash.global_position.y = [ground_y_above, ground_y_below].pick_random() if not is_gap else ground_y_above
