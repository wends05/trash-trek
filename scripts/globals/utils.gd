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
	Hurt
}

enum SceneType {
	Gameplay,
	Menu,
	Credits,
	Tutorial,
	GameOver,
}

const TRASHES = [
	preload("res://resources/trash_resource/biodegradable/branches.tres"),
	preload("res://resources/trash_resource/biodegradable/crumpled.tres"),
	preload("res://resources/trash_resource/biodegradable/pile_of_leaves.tres"),
	preload("res://resources/trash_resource/recyclable/box.tres"),
	preload("res://resources/trash_resource/recyclable/tin_can.tres"),
	preload("res://resources/trash_resource/recyclable/water_bottle.tres"),
	preload("res://resources/trash_resource/toxic_waste/battery.tres"),
	preload("res://resources/trash_resource/toxic_waste/face_mask.tres"),
	preload("res://resources/trash_resource/toxic_waste/gloves.tres"),
	]

const TRASHBINS = [
	preload("res://resources/trashbins/Recyclable.tres"),
	preload("res://resources/trashbins/Biodegradable.tres"),
	preload("res://resources/trashbins/ToxicWaste.tres"),
]

const TRASHBINICONS := [
	preload("res://assets/trashbins/labels/Recyclable.png"),
	preload("res://assets/trashbins/labels/Biodegradable.png"),
	preload("res://assets/trashbins/labels/ToxicWaste.png")
]

func get_enum_name(enum_dict: Dictionary, value: int) -> String:
	for key in enum_dict.keys():
		if enum_dict[key] == value:
			return key
	return ""

func get_random_trash_item() -> TrashResource:
	var items = TRASHES
	return items[randi() % items.size()]

func get_trash_bin(trash_type: Utils.TrashType) -> TrashBinResource:
	var items = TRASHBINS
	return items[trash_type]

func get_trash_bin_icon(trash_type: Utils.TrashType) -> Texture:
	var items = TRASHBINICONS
	return items[trash_type]
		
func anim_player(player: AnimationPlayer, anim_name: String) -> void:
	if player and player.has_animation(anim_name):
		player.play(anim_name)
