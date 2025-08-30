extends Node2D

class_name TerrainManager

@export var speed: float = 200
@export var terrain_width: int = 1024
@onready var terrain_manager: Node = $"."

enum TerrainType {Start, Terrain1, Terrain2, Terrain3}

var terrain_scenes := {
	TerrainType.Start: preload("res://scenes/terrains/Start.tscn"),
	TerrainType.Terrain1: preload("res://scenes/terrains/Terrain1.tscn"),
	TerrainType.Terrain2: preload("res://scenes/terrains/Terrain2.tscn"),
	TerrainType.Terrain3: preload("res://scenes/terrains/Terrain3.tscn")
}

var current_terrain_index := 0
var start_terrain_loaded := false

func _ready() -> void:
	randomize() #for randi to generate random result each run
	initialize_terrain() # generate the first two terrains

func _physics_process(delta: float) -> void:     
	scroll_terrain(delta)

func initialize_terrain() -> void:
	load_terrain(0, 0)
	load_terrain(terrain_width, 0)

func scroll_terrain(delta: float) -> void:
	for area in terrain_manager.get_children():
		area.position.x -= speed * delta
		if area.position.x < -1024:
			load_terrain(area.position.x + 2048, 0)
			area.queue_free()

func load_terrain(x, y):
	if not start_terrain_loaded:
		var scene = terrain_scenes[TerrainType.Start].instantiate()
		scene.position = Vector2(x, y)
		terrain_manager.add_child(scene)
		start_terrain_loaded = true
	else:
		var terrain_types = [TerrainType.Terrain1, TerrainType.Terrain2, TerrainType.Terrain3]
		var terrain_type = terrain_types[current_terrain_index]
		current_terrain_index = (current_terrain_index + 1) % terrain_types.size()
		var scene = terrain_scenes[terrain_type].instantiate()
		scene.position = Vector2(x, y)
		terrain_manager.add_child(scene)
