extends Area2D

class_name GroundArea

@export var ground_y: int

func _ready() -> void:
	area_entered.connect(detect_area)

func detect_area(area:Area2D):
	if area.get_parent() is Trash:
		bring_trash_to_ground(area.get_parent())

func bring_trash_to_ground(trash: Trash):
	trash.global_position.y = ground_y
