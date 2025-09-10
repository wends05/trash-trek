class_name CastShadow extends Node2D

@onready var raycast_2d: RayCast2D = $RayCast2D
@onready var pointlight_2d: Light2D = $PointLight2D

var ray_y_collision: float = 0.0


func _physics_process(_delta: float) -> void:
	if raycast_2d.is_colliding():
		ray_y_collision = raycast_2d.get_collision_point().y
	else:
		ray_y_collision = raycast_2d.global_position.y + raycast_2d.target_position.y

	pointlight_2d.global_position.y = ray_y_collision
	pointlight_2d.energy = max(1.0 - pointlight_2d.position.y / raycast_2d.target_position.y, 0.0)
