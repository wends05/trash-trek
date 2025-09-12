extends Node2D

class_name TerrainManager

@export var speed: float = 200
@export var terrain_width: int = 1180
@onready var terrain_manager: Node = $"."
@export var gap_size: int = 130
@export var acceleration: float = 5.0 
@export var max_speed: float = 600 
@export var base_speed: float = 200.0
@export var meters_per_minute: float = 1000.0

var last_terrains := []  # stores recent terrain types (most recent appended)
const MAX_HISTORY := 2  # Number of terrains to remember and avoid

enum TerrainType {Start, Terrain1, Terrain2, Terrain3, Terrain4, Terrain5, Terrain6}

var terrain_scenes := {
	TerrainType.Start: preload("res://scenes/terrains/Start.tscn"),
	TerrainType.Terrain1: preload("res://scenes/terrains/Terrain1.tscn"),
	TerrainType.Terrain2: preload("res://scenes/terrains/Terrain2.tscn"),
	TerrainType.Terrain3: preload("res://scenes/terrains/Terrain3.tscn"),
	TerrainType.Terrain4: preload("res://scenes/terrains/Terrain4.tscn"),
	TerrainType.Terrain5: preload("res://scenes/terrains/Terrain5.tscn"),
	TerrainType.Terrain6: preload("res://scenes/terrains/Terrain6.tscn")
}

var current_terrain_index := 0
var start_terrain_loaded := false

func _ready() -> void:
	randomize() #for randi to generate random result each run
	initialize_terrain() # generate the first two terrains

func _physics_process(delta: float) -> void:     
	speed = min(speed + acceleration * delta, max_speed)
	scroll_terrain(delta) 
	var meters_per_second = (speed / base_speed) * (meters_per_minute / 60.0)
	Game.time_changed.emit((speed * Game.elapsed_time/ meters_per_second))

func initialize_terrain() -> void:
	load_terrain(0, 0)
	load_terrain(terrain_width + gap_size, 0)

func scroll_terrain(delta: float) -> void:
	for area in terrain_manager.get_children():
		area.position.x -= speed * delta
		if area.position.x < -terrain_width:
			load_terrain(area.position.x + terrain_width * 2 + gap_size, 0)
			area.queue_free()


func load_terrain(x, y):
	if not start_terrain_loaded:
		var scene = terrain_scenes[TerrainType.Start].instantiate()
		scene.position = Vector2(x, y)
		terrain_manager.add_child(scene)
		start_terrain_loaded = true
		last_terrains.clear()  # Clear terrain history at start
	else:
		var terrain_types = [TerrainType.Terrain1, TerrainType.Terrain2, TerrainType.Terrain3, TerrainType.Terrain4, TerrainType.Terrain5, TerrainType.Terrain6 ]
		
		# Remove the last two used terrains from available options
		for used_terrain in last_terrains:
			terrain_types.erase(used_terrain)
		
		# If we've run out of terrain types (shouldn't happen with 6+ terrains)
		if terrain_types.is_empty():
			terrain_types = [TerrainType.Terrain1, TerrainType.Terrain2, TerrainType.Terrain3, 
						   TerrainType.Terrain4, TerrainType.Terrain5, TerrainType.Terrain6]
			# Still avoid the most recent terrain if possible
			if not last_terrains.is_empty():
				terrain_types.erase(last_terrains[0])
		
		# Randomly select from remaining terrains
		var terrain_type = terrain_types[randi() % terrain_types.size()]
		
		# Update the history of used terrains
		last_terrains.push_front(terrain_type)
		# Keep only the last MAX_HISTORY terrains
		if last_terrains.size() > MAX_HISTORY:
			last_terrains.pop_back()
		
		# Instantiate the selected terrain
		var scene = terrain_scenes[terrain_type].instantiate()
		scene.position = Vector2(x + gap_size, y)
		terrain_manager.add_child(scene)
