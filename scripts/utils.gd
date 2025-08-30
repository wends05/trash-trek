extends Node

enum TrashType {
	Recyclable,
	Biodegradable,
	ToxicWaste
}

enum GameStateType {
	Pause,
	Play,
}

enum UIStateType {
	Settings,
	PauseMenu,
	GameOver,
}

enum GameOverReason {
	None,
	OutOfBounds,
	Fell,
	OutOfEnergy,
}

enum PlayerMotion {
	Jump,
	Fall,
	Run,
	Hurt,
}

const TRASHES = [
	preload("res://trash_resource/biodegradable/branches.tres"),
	preload("res://trash_resource/biodegradable/crumpled.tres"),
	preload("res://trash_resource/biodegradable/pile_of_leaves.tres"),
	preload("res://trash_resource/recyclable/box.tres"),
	preload("res://trash_resource/recyclable/tin_can.tres"),
	preload("res://trash_resource/recyclable/water_bottle.tres"),
	preload("res://trash_resource/toxic_waste/battery.tres"),
	preload("res://trash_resource/toxic_waste/face_mask.tres"),
	preload("res://trash_resource/toxic_waste/gloves.tres"),
	]

func get_enum_name(enum_dict: Dictionary, value: int) -> String:
	for key in enum_dict.keys():
		if enum_dict[key] == value:
			return key
	return ""

func get_random_trash_item() -> TrashResource:
	var items = TRASHES
	return items[randi() % items.size()]
