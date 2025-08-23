extends Node2D

class_name Trash

@export var type: Utils.TrashType = Utils.TrashType.Recyclable
@export var terrain_manager: TerrainManager

@onready var area = $Area

func _ready() -> void:
	add_to_group("Trash")
	
	$Label.text = "%s" % Utils.get_enum_name(Utils.TrashType, type)

func _physics_process(delta: float) -> void:
	position.x -= terrain_manager.speed * delta

func remove():
	queue_free()
