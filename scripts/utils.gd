extends Node

enum TrashType {
	Recyclable,
	Biodegradable,
	ToxicWaste
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
