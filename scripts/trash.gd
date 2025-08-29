extends Node2D

class_name Trash

@export var type: Utils.TrashType = Utils.TrashType.Recyclable
@export var terrain_manager: TerrainManager
@onready var trash_label: Label = $Label
@onready var trash_texture: Sprite2D = $Area/Sprite2D
var trash_item_resource: TrashResource

func _ready() -> void:
	trash_item_resource = Utils.get_random_trash_item()
	var texture_path = trash_item_resource.get_trash_texture_path()
	
	var texture = load(texture_path) 
	trash_texture.texture = texture

	add_to_group("Trash")
	
	trash_label.text = "%s: %s" % [trash_item_resource.trash_type, trash_item_resource.trash_name]

func _physics_process(delta: float) -> void:
	position.x -= terrain_manager.speed * delta

func remove():
	queue_free()

func _on_area_area_entered(area: Area2D) -> void:
	if area is GroundArea:
		area.bring_trash_above(self, 0)
