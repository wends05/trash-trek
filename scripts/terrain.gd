extends Node2D 

class_name Terrain

@onready var trash_spawns: Node2D
var max_markers: int = 0
@export var trash_bin_spawns: Array[Marker2D] = []

func _ready() -> void:

	if name == "Start":
		return
	
	trash_spawns = $TrashSpawns

	max_markers = trash_spawns.get_child_count()

	if Game.trash_bin_countdown == 0:
		spawn_trash_bin()
		Game.reset_trash_bin_countdown()
	else:
		spawn_trashes()
		Game.decrease_trash_bin_countdown()
	
func spawn_trashes():
	if max_markers == 0:
		return
		
	var chosen_spawners = range(max_markers)
	chosen_spawners.shuffle()
	chosen_spawners = chosen_spawners.slice(0, randi_range(1, max_markers - 2))

	for i in chosen_spawners:
		var trash: Trash = preload("res://scenes/trash.tscn").instantiate()

		var randtype = randi_range(0, Utils.TrashType.size() - 1)
		trash.type = randtype as Utils.TrashType
		trash_spawns.get_children()[i].add_child(trash)

func spawn_trash_bin():
	if max_markers == 0:
		return
	if trash_bin_spawns.is_empty():
		printerr("No trash bin spawn set")
		return
		
	var count := 1
	if Game.elapsed_time >= 30:
		var chance := 0.4
		if Game.elapsed_time >= 60:
			chance = 0.6 
		if randf() < chance:
			count = 2
		print("TRUEE ELAPSED")
	var chosen = trash_bin_spawns.duplicate()
	chosen.shuffle()
	chosen = chosen.slice(0, count)	
	for marker in chosen:
		var trash_bin: TrashBin = preload("res://scenes/TrashBin.tscn").instantiate()

		var randtype = randi_range(0, Utils.TrashType.size() - 1)
		trash_bin.type = randtype as Utils.TrashType


		marker.add_child(trash_bin)
