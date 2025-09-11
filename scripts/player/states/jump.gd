extends State
class_name Jump

# Jump tuning parameters
@export var initial_jump_force: float = -400.0 # Initial jump burst (negative = up)
var jump_boost: float = 0
var final_jump_boost: float = 0

@export var hold_max_force: float = -200.0 # Additional upward force when fully held
@export var max_jump_timer: float = 0.3 # How long holding jump adds force
@export var fall_gravity_multiplier: float = 1.5 # Faster fall for better feel

@export_category("Nodes")
@export var animation: AnimationPlayer
@export var player: Player

var jump_timer: float = 0.0
var _current_force: float = 0.0

var is_jumping: bool = false

@export var jump_boost_resource: UpgradeResource = preload("res://resources/shop/upgrades/jumpboost.tres")


func _ready() -> void:
	var jump_boost_upgrade = player.player_stats_resource.find_upgrade("Jump Boost")

	if not jump_boost_upgrade:
		print("No jump boost found")
		final_jump_boost = initial_jump_force
		return
	final_jump_boost = initial_jump_force + jump_boost_upgrade.level * jump_boost_resource.stat_increase_per_level
	

func enter():
	# If a hurt-triggered lockout is active, immediately abort to running/falling (don't allow buffered jump)
	if player.block_jump_after_hurt:
		# Decide appropriate fallback state
		if player.is_on_floor():
			transitioned.emit(self, "running")
		else:
			transitioned.emit(self, "falling")
		return

	animation.play("jump")
	
	# Initialize jump
	jump_timer = 0.0
	_current_force = final_jump_boost
	is_jumping = true
	player.velocity.y = final_jump_boost

func physics_update(delta: float):
	var gravity_y := player.get_gravity().y # positive downward
	
	if player.velocity.y < 0: # Rising
		if Input.is_action_pressed("jump") and is_jumping and jump_timer < max_jump_timer:
			# Add more upward force while holding jump
			jump_timer += delta
			var target_force := final_jump_boost + (hold_max_force * jump_timer)
			
			# Only boost if we're slower than the target force
			if player.velocity.y > target_force:
				player.velocity.y = target_force
				_current_force = target_force
		else:
			player.velocity.y += gravity_y * delta
	else: # Falling
		player.velocity.y += gravity_y * fall_gravity_multiplier * delta
	
	player.move_and_slide()
	
	# Transition to running when landing
	if player.is_on_floor():
		transitioned.emit(self, "running")
		return
	
	# Transition to falling if we're heading downward
	if player.velocity.y > 0:
		transitioned.emit(self, "falling")
		return

func exit():
	is_jumping = false
