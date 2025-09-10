extends State
class_name Jump

# Jump tuning parameters
@export var initial_jump_force: float = -400.0 # Initial jump burst (negative = up)
var jump_boost: float = 0
var final_jump_boost: float = 0

@export var hold_max_force: float = -200.0 # Additional upward force when fully held
@export var hold_time: float = 0.3 # How long holding jump adds force
@export var fall_gravity_multiplier: float = 1.5 # Faster fall for better feel
@export var short_hop_multiplier: float = 2.0 # Extra gravity when released early

@export_category("Nodes")
@export var animation: AnimationPlayer
@export var player: Player

var _hold_timer: float = 0.0
var _current_force: float = 0.0
var _has_released: bool = false

@export var jump_boost_resource: UpgradeResource = preload("res://resources/shop/upgrades/jumpboost.tres")


func _ready() -> void:
	var jump_boost_upgrade = player.player_stats_resource.find_upgrade("Jump Boost")

	if not jump_boost_upgrade:
		printerr("No jump boost found")
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
	_hold_timer = 0.0
	_current_force = final_jump_boost
	_has_released = false
	player.velocity.y = final_jump_boost

func physics_update(delta: float):
	var gravity_y := player.get_gravity().y # positive downward
	
	if player.velocity.y < 0: # Rising
		if Input.is_action_pressed("jump") and not _has_released and _hold_timer < hold_time:
			# Add more upward force while holding jump
			_hold_timer += delta
			var t := _hold_timer / hold_time # 0 to 1 progress
			t = ease(t, 0.5) # Smooth acceleration curve
			var target_force := (initial_jump_force - jump_boost) + (hold_max_force * t)
			
			# Only boost if we're slower than the target force
			if player.velocity.y > target_force:
				player.velocity.y = target_force
				_current_force = target_force
		else:
			_has_released = true
			# Early release = stronger gravity
			player.velocity.y += gravity_y * short_hop_multiplier * delta
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
	pass
