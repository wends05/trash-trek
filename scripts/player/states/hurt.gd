extends State
class_name Hurt

@export_category("Nodes")

@export var animation: AnimationPlayer
@export var player: Player

@export var jump_lockout_time: float = 0.05
@export var cancel_upward_velocity: bool = true
@export var downward_impulse: float = 80.0

var hurt_sfx = preload("res://audios/hurt (1).mp3")
var _lockout_timer: float = 0.05
var _connected: bool = false

func enter():
	player.is_hurt = true
	player.block_jump_after_hurt = true
	AudioManager.play_sfx(hurt_sfx)
	_lockout_timer = jump_lockout_time
	player.velocity.x = 0.0
	if cancel_upward_velocity and player.velocity.y < 0.0:
		player.velocity.y = 0.0
	if downward_impulse > 0.0:
		player.velocity.y += downward_impulse

	animation.play("hurt") # ensure animation called exactly "hurt" and not looping

	# Reconnect every time (safe even if previously connected)
	if not _connected:
		animation.animation_finished.connect(_on_hurt_finished, CONNECT_ONE_SHOT)
		_connected = true

func physics_update(delta: float):
	if _lockout_timer > 0.0:
		_lockout_timer -= delta
	elif player.block_jump_after_hurt:
		player.block_jump_after_hurt = false
	player.move_and_slide()

func _on_hurt_finished(anim_name: StringName):
	# Only react to the hurt animation
	if anim_name != "hurt":
		return
	_connected = false
	if player.is_on_floor():
		transitioned.emit(self, "running")
	else:
		transitioned.emit(self, "falling")

func exit():
	player.is_hurt = false
