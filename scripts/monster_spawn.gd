extends Marker2D

class_name MonsterSpawner

func _ready() -> void:
	if Game.difficulty_step >= 20:
		var spawn_rate = randf()
		if spawn_rate <= 0.6:
			spawn_monster()

func spawn_monster():
	
