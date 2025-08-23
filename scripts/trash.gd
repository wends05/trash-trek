extends Node2D

class_name Trash

@export var type: Utils.TrashType = Utils.TrashType.Recyclable
@export var main: Main

@onready var area = $Area

func _ready() -> void:
	add_to_group("Trash")

	if not main:
		main = get_tree().get_root().get_node("Main")
	
	$Label.text = "%s" % Utils.get_enum_name(Utils.TrashType, type)

func _physics_process(delta: float) -> void:
	position.x -= main.speed * delta

func remove():
	queue_free()
