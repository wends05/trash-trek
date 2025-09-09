extends Node2D

class_name Monster

@export var type: Utils.TrashType
@onready var player_collision_area: CollisionObject2D = get_node_or_null("PlayerCollisionArea")
@export var anim : AnimatedSprite2D

func _ready() -> void:
	await anim.animation_finished
	anim.play("idle")
	
