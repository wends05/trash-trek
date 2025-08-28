extends Resource

class_name  TrashResource



@export var trash_name: String = ""
@export_enum("Recyclable", "Biodegradable", "ToxicWaste") var trash_type: String = "Recyclable"

func get_trash_texture_path() -> String:
	return "res://assets/trash/%s/%s.png" % [trash_type, trash_name]
