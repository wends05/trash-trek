extends Node2D

class_name TrashBin


@export var type: Utils.TrashType
@export var terrain_manager: TerrainManager

func _ready() -> void:
	var texture_path = "res://assets/trashbins/%s.png" % Utils.get_enum_name(Utils.TrashType, type)
	$Asset.texture = load(texture_path)

func _physics_process(delta: float) -> void:
	position.x -= terrain_manager.speed * delta

func _on_area_area_entered(area: Area2D) -> void:
	if area is GroundArea:
		area.bring_trash_above(self)
