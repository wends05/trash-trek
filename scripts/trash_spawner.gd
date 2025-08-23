extends Node2D

class_name Spawner

@export var terrain_manager: TerrainManager
@onready var trash_timer: Timer = $TrashTimer
@onready var trash_bin_timer: Timer = $TrashBinTimer

func create_trash():
	var random_item = randi_range(1, 9)
	var trash: Trash = preload("res://scenes/trash.tscn").instantiate()
	
	var randtype = randi_range(0, 2)
	trash.type = randtype as Utils.TrashType
	
	trash.global_position.x = terrain_manager.terrain_width + 500
	trash.global_position.y = 632
	trash.terrain_manager = terrain_manager
	
	
	add_child(trash)
	trash_timer.start(5)
	await trash_timer.timeout
	create_trash()

func create_trash_bins():
	var random_trash_bin = randi_range(1, 3)
	var trash_bin: TrashBin = preload("res://scenes/TrashBin.tscn").instantiate()
	
	var randtype = randi_range(0, 2)
	trash_bin.type = randtype as Utils.TrashType
	
	trash_bin.global_position.x = terrain_manager.terrain_width + 500
	trash_bin.global_position.y = 632
	trash_bin.terrain_manager = terrain_manager
	
	add_child(trash_bin)
	trash_bin_timer.start(1)
	await trash_bin_timer.timeout
	create_trash_bins()

func _ready() -> void:
	create_trash()
	create_trash_bins()
