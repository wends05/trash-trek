extends Marker2D

class_name MonsterSpawner

var monster_scenes: Array[PackedScene] = [
	preload("res://scenes/monsters/biodegradable_monster.tscn"),
	preload("res://scenes/monsters/recyclable_monster.tscn"),
	preload("res://scenes/monsters/toxic_waste_monster.tscn")
]


func _ready() -> void:
	var spawn_rate := 0.0
	if Game.elapsed_time >= 60:
		spawn_rate = 0.5 
	elif Game.elapsed_time >= 20:
		spawn_rate = 0.4 
	else:
		return 
		
	if randf() < spawn_rate:
		spawn_monster()

func spawn_monster() -> void:
	var idx: int = randi_range(0, monster_scenes.size() - 1)
	var scene: PackedScene = monster_scenes[idx]
	if scene == null:
		return
	var monster: Monster = scene.instantiate()
	if monster == null:
		return
	
	add_child(monster)
	
