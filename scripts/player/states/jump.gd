extends State

class_name Jump

# Tweakable jump parameters (export so you can tune in Inspector)
@export var max_hold_time: float = 0.2 # seconds the jump button can influence ascent
@export var base_jump_force: float = -290.0 # initial impulse (negative = up)
@export var max_additional_force: float = -260.0 # additional force reached at full hold (added ON TOP of base resulting target ~ base + additional)
@export var short_hop_gravity_multiplier: float = 2.0 # extra gravity when button released early
@export var fall_gravity_multiplier: float = 1.0 # gravity once upward velocity ends

var hold_timer: float = 0.0
var target_peak_force: float = 0.0

@onready var animated_sprite: AnimatedSprite2D = get_parent().get_parent().get_node("AnimatedSprite2D")
@onready var player: Player = get_parent().get_parent()

func enter():
	# If a hurt-triggered lockout is active, immediately abort to running/falling (don't allow buffered jump)
	if player.block_jump_after_hurt:
		# Decide appropriate fallback state
		if player.is_on_floor():
			transitioned.emit(self, "running")
		else:
			transitioned.emit(self, "falling")
		return
	animated_sprite.play("jump")
	player.velocity.y = base_jump_force
	target_peak_force = base_jump_force + max_additional_force
	hold_timer = 0.0

func physics_update(delta: float):
	var gravity_y := player.get_gravity().y # positive downward

	if player.velocity.y < 0: # still ascending
		if Input.is_action_pressed("jump") and hold_timer < max_hold_time:
			hold_timer += delta
			var t: float = clamp(hold_timer / max_hold_time, 0.0, 1.0)
			# Interpolate toward peak force (more negative)
			var desired: float = lerpf(base_jump_force, target_peak_force, t)
			if player.velocity.y > desired: # velocity.y increases downward, so '>' means we lost upward speed; reinforce
				player.velocity.y = desired
		else:
			# Early release -> apply stronger gravity for short hop feel
			player.velocity.y += gravity_y * short_hop_gravity_multiplier * delta
	else:
		# Descending: normal / slightly faster gravity
		player.velocity.y += gravity_y * fall_gravity_multiplier * delta

	player.move_and_slide()

	# Transition to running when landing
	if player.is_on_floor():
		transitioned.emit(self, "running")
		return

	# Transition to falling when descending (velocity.y > 0)
	if player.velocity.y > 0:
		transitioned.emit(self, "falling")
		return

func exit():
	pass
