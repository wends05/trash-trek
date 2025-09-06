extends Sprite2D

@export_node_path("CharacterBody2D") var player_path: NodePath
@export var floor_collision_mask: int = 2 # e.g. only Ground layer (Layer 2)
@export var cast_distance: float = 64.0
@export var show_distance_threshold: float = 24.0 # hide shadow if drop > this
@export var x_offset: float = 0.0
@export var y_offset: float = 6.0
@export var foot_cast_offset_y: float = 6.0 # start the ray a bit below player origin
@export var smooth: float = 18.0

@onready var player: CharacterBody2D = get_node_or_null(player_path)

func _physics_process(delta: float) -> void:
	if player == null:
		return

	# Cast straight down from player's feet
	var from: Vector2 = player.global_position + Vector2(0, foot_cast_offset_y)
	var to: Vector2 = from + Vector2(0, cast_distance)

	var space: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
	var q := PhysicsRayQueryParameters2D.create(from, to)
	q.collision_mask = floor_collision_mask
	q.collide_with_areas = false
	q.exclude = [player.get_rid()]

	var hit: Dictionary = space.intersect_ray(q)

	var target_x: float = player.global_position.x + x_offset
	var k: float = clampf(smooth * delta, 0.0, 1.0)

	if not hit.is_empty():
		var hit_pos: Vector2 = hit.position
		# Measure drop from ray start, not from player origin
		var drop: float = hit_pos.y - from.y

		# Show only if ground is below and close enough (not a far floor under a pit)
		if drop > 0.0 and drop <= show_distance_threshold:
			var target_y: float = hit_pos.y + y_offset
			global_position = Vector2(
				lerpf(global_position.x, target_x, k),
				lerpf(global_position.y, target_y, k)
			)
			visible = true
			return

	# No valid ground directly under us -> hide and keep under player
	visible = false
	global_position.x = target_x
	global_position.y = player.global_position.y + y_offset
