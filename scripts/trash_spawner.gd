extends Node2D

class_name TrashSpawner

@export var terrain_manager: TerrainManager
@onready var timer: Timer = $Timer

func create_trash():
	var random_item = randi_range(1, 9)
	var trash = preload("res://scenes/trash.tscn").instantiate()
	trash.global_position.x = terrain_manager.terrain_width + 500
	trash.global_position.y = 632
	trash.terrain_manager = terrain_manager
	var randtype = randi_range(0, 2)
	
	trash.type = randtype
	
	add_child(trash)
	timer.start(1)
	await timer.timeout
	create_trash()

func _ready() -> void:
	create_trash()
