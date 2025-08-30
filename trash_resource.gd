extends Resource

class_name TrashResource

@export var trash_name: String = ""
@export var trash_type: Utils.TrashType = Utils.TrashType.Recyclable

func get_trash_texture_path() -> String:
	return "res://assets/trash/%s/%s.png" % [Utils.get_enum_name(Utils.TrashType, trash_type), trash_name]
