extends Node

enum TrashType {
	Recyclable,
	Biodegradable,
	ToxicWaste
}

# Define available trash items for each type (exact file names)
const TRASH_ITEMS = {
	TrashType.Recyclable: ["Box", "Tin Can", "water bottle"],
	TrashType.Biodegradable: ["Branches", "crumpled-1", "pile of leaves (1)"],
	TrashType.ToxicWaste: ["Battery-1", "face mask", "gloves"]
}

# Define folder names for each type (to match actual folder structure)
const TRASH_FOLDERS = {
	TrashType.Recyclable: "Recyclable",
	TrashType.Biodegradable: "Biodegradable",
	TrashType.ToxicWaste: "Toxicwaste"
}
enum GameStateType {
	Win,
	Lose,
	Pause,
	Play,
}

enum UIStateType {
	Settings,
	PauseMenu,
	WinScreen,
	LoseScreen,
}

func get_enum_name(enum_dict: Dictionary, value: int) -> String:
	for key in enum_dict.keys():
		if enum_dict[key] == value:
			return key
	return ""

func get_random_trash_item(trash_type: TrashType) -> String:
	var items = TRASH_ITEMS[trash_type]
	return items[randi() % items.size()]

func get_trash_texture_path(trash_type: TrashType, item_name: String = "") -> String:
	var folder = TRASH_FOLDERS[trash_type]
	if item_name.is_empty():
		item_name = get_random_trash_item(trash_type)
	return "res://assets/trash/%s/%s.png" % [folder, item_name]
