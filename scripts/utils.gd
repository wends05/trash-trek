extends Node

enum TrashType {
	Recyclable,
	Biodegradable,
	ToxicWaste
}

func get_enum_name(enum_dict: Dictionary, value: int) -> String:
	for key in enum_dict.keys():
		if enum_dict[key] == value:
			return key
	return ""
