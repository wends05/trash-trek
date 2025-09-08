extends State

@export_category("Nodes")

@export var animation: AnimationPlayer
@export var player: Player

func enter():
	animation.play("falling")

func physics_update(delta: float):
	player.velocity.y += player.get_gravity().y * delta
	player.move_and_slide()

	if player.is_on_floor():
		transitioned.emit(self, "running")
		return

	# Air jump (double jump) support, only if button was released since last press
	if Input.is_action_just_pressed("jump") and not player.is_hurt and not Input.is_action_pressed("jump"):
		if player.air_jumps_left > 0:
			player.air_jumps_left -= 1
			# Use same force as initial jump for consistency
			player.velocity.y = -400.0
			transitioned.emit(self, "jump")
