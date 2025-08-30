extends Node2D

class_name Trash

@export var type: Utils.TrashType = Utils.TrashType.Recyclable
@onready var trash_label: Label = $Label
@onready var trash_texture: Sprite2D = $Area/Sprite2D
var trash_item_resource: TrashResource

func _ready() -> void:
	load_trash()

func remove():
	queue_free()

func load_trash() -> void:
	trash_item_resource = Utils.get_random_trash_item()
	var texture_path = trash_item_resource.get_trash_texture_path()

	type = trash_item_resource.trash_type
	
	var texture = load(texture_path) 
	trash_texture.texture = texture
	trash_label.text = "%s: %s" % [Utils.get_enum_name(Utils.TrashType, type), trash_item_resource.trash_name]
