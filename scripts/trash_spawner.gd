extends Node2D

class_name TrashSpawner

@export var main: Main
@onready var timer: Timer = $Timer

func create_trash():
	var random_item = randi_range(1, 9)
	var trash = preload("res://scenes/trash.tscn").instantiate()
	trash.global_position.x = main.terrain_width
	trash.global_position.y = randi_range(448, 584)
	
	var randtype = randi_range(0, 2)
	
	trash.type = randtype
	
	add_child(trash)
	timer.start(1)
	await timer.timeout
	create_trash()

func _ready() -> void:
	create_trash()
