extends Node2D

class_name Spawner

@export var terrain_manager: TerrainManager
@onready var trash_timer: Timer = $TrashTimer
var trash_count = 0
var trash_countdown = 4


func create_trash():
	var trash: Trash = preload("res://scenes/trash.tscn").instantiate()
	
	
	trash.global_position.x = terrain_manager.terrain_width + 500
	trash.global_position.y = 632
	trash.terrain_manager = terrain_manager
	
	add_child(trash)
	var random_timer_time = randi_range(2,3)
	trash_timer.start(random_timer_time)
	await trash_timer.timeout
	if trash_countdown == trash_count:
		create_trash_bin()
		trash_count = 0
		trash_countdown = randi_range(0, 6)
		return
	trash_count += 1
	create_trash()

func create_trash_bin():
	var trash_bin: TrashBin = preload("res://scenes/TrashBin.tscn").instantiate()
	
	var randtype = randi_range(0, 2)
	trash_bin.type = randtype as Utils.TrashType
	
	trash_bin.global_position.x = terrain_manager.terrain_width + 500
	trash_bin.global_position.y = 632
	trash_bin.terrain_manager = terrain_manager
	
	add_child(trash_bin)
	var random_timer_time = randi_range(2,3)
	trash_timer.start(random_timer_time)
	await trash_timer.timeout
	create_trash()

func _ready() -> void:
	trash_countdown = randi_range(2,4)
	create_trash()
