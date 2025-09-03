extends State

class_name Hurt

@onready var animated_sprite: AnimatedSprite2D = get_parent().get_parent().get_node("AnimatedSprite2D")
@onready var player: Player = get_parent().get_parent()

var _connected: bool = false
@export var jump_lockout_time: float = 0.15 # seconds after hurt finished before a jump can start
var _lockout_timer: float = 0.0
@export var cancel_upward_velocity: bool = true # If true, negate any ongoing jump ascent
@export var downward_impulse: float = 80.0 # Extra downward push to stop upward motion (0 = none)

func enter():
	player.is_hurt = true
	player.block_jump_after_hurt = true
	_lockout_timer = jump_lockout_time
	# Cancel horizontal motion for a brief stun feeling
	player.velocity.x = 0.0
	# Stop upward motion so pre-collision jump doesn't still give full height
	if cancel_upward_velocity and player.velocity.y < 0.0:
		player.velocity.y = 0.0
	if downward_impulse > 0.0:
		player.velocity.y += downward_impulse # gravity-positive direction (down)
	animated_sprite.play("hurt")
	if not _connected:
		animated_sprite.animation_finished.connect(_on_hurt_finished, CONNECT_ONE_SHOT)
		_connected = true

func physics_update(delta: float):
	# Countdown jump lockout while hurt
	if _lockout_timer > 0.0:
		_lockout_timer -= delta
	if _lockout_timer <= 0.0 and player.block_jump_after_hurt:
		player.block_jump_after_hurt = false
	player.move_and_slide()

func _on_hurt_finished():
	_connected = false
	# Decide next state based on grounded status
	if player.is_on_floor():
		transitioned.emit(self, "running")
	else:
		transitioned.emit(self, "falling")

func exit():
	player.is_hurt = false
