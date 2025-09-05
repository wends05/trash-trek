extends State
class_name Running

@onready var animation: AnimationPlayer = get_parent().get_parent().get_node("AnimationPlayer")
@onready var player: Player = get_parent().get_parent()

@export var recenter_smooth_time: float = 0.75
@export var recenter_max_speed: float = 400.0
@export var recenter_snap_distance: float = 1.5
@export var reanchor_each_run: bool = false

var _anchor_x: float = INF
var _recenter_velocity: float = 0.0

func enter():
	animation.play("running")
	if _anchor_x == INF or reanchor_each_run:
		_anchor_x = player.global_position.x
		_recenter_velocity = 0.0

func physics_update(delta: float):
	if not player.is_on_floor():
		transitioned.emit(self, "falling")
		return
	if Input.is_action_just_pressed("jump") and not player.is_hurt:
		transitioned.emit(self, "jump")
		return

	player.velocity.x = 0.0

	if _anchor_x != INF:
		player.global_position.x = _smooth_damp_x(player.global_position.x, _anchor_x, delta)
		if abs(_anchor_x - player.global_position.x) <= recenter_snap_distance:
			player.global_position.x = _anchor_x
			_recenter_velocity = 0.0

	player.move_and_slide()

func _smooth_damp_x(current: float, target: float, delta: float) -> float:
	var smooth_time: float = max(0.0001, recenter_smooth_time)
	var omega: float = 2.0 / smooth_time
	var x: float = omega * delta
	var decay: float = 1.0 / (1.0 + x + 0.48 * x * x + 0.235 * x * x * x)
	var change: float = current - target
	var max_change: float = recenter_max_speed * smooth_time
	change = clampf(change, -max_change, max_change)
	var temp: float = (_recenter_velocity + omega * change) * delta
	_recenter_velocity = (_recenter_velocity - omega * temp) * decay
	return target + (change + temp) * decay
