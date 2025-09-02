extends State

class_name Hurt

@onready var animated_sprite: AnimatedSprite2D = get_parent().get_parent().get_node("AnimatedSprite2D")
@onready var player: Player = get_parent().get_parent()

var _connected: bool = false

func enter():
	player.is_hurt = true
	player.velocity = Vector2.ZERO
	animated_sprite.play("hurt")
	# Connect once per enter (using oneshot to auto-disconnect when fired)
	if not _connected:
		animated_sprite.animation_finished.connect(_on_hurt_finished, CONNECT_ONE_SHOT)
		_connected = true

func physics_update(_delta: float):
	# Hurt state is passive; no movement besides existing velocity damping
	pass

func _on_hurt_finished():
	_connected = false
	# Decide next state based on grounded status
	if player.is_on_floor():
		transitioned.emit(self, "running")
	else:
		transitioned.emit(self, "falling")

func exit():
	player.is_hurt = false
