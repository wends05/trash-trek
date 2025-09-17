extends State

@export_category("Nodes")

@export var animation: AnimationPlayer
@export var player: Player

# Jump buffer + landing grace
@export var jump_buffer_time: float = 0.1 # Press before landing; fires on touchdown
@export var post_land_grace_time: float = 0.1 # Time after landing you can still press to re-jump

# Timers/flags
var _buffer_timer: float = 0.0
var _land_grace_timer: float = 0.0
var _was_on_floor: bool = false

func enter():
	animation.play("falling")
	_was_on_floor = player.is_on_floor()
	_land_grace_timer = 0.0

func physics_update(delta: float):
	# Record buffered jump while airborne
	if Input.is_action_just_pressed("jump"):
		_buffer_timer = jump_buffer_time
	else:
		_buffer_timer = max(0.0, _buffer_timer - delta)

	player.velocity.y += player.get_gravity().y * delta
	player.move_and_slide()

	# Landing/grace handling
	var on_floor := player.is_on_floor()
	if on_floor and not _was_on_floor:
		# Just landed
		_land_grace_timer = post_land_grace_time
	_was_on_floor = on_floor

	if on_floor:
		_land_grace_timer = max(0.0, _land_grace_timer - delta)
		# Buffered pre-landing press OR pressed during grace -> jump now
		if _buffer_timer > 0.0 or (Input.is_action_pressed("jump") and _land_grace_timer > 0.0):
			_buffer_timer = 0.0
			_land_grace_timer = 0.0
			transitioned.emit(self, "jump")
			return

		# No jump within grace -> go to running
		if _land_grace_timer <= 0.0:
			transitioned.emit(self, "running")
			return
