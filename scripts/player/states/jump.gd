extends State
class_name Jump

# Jump tuning parameters
@export var initial_jump_force: float = -460.0 # Initial upward impulse (negative = up)
var final_jump_boost: float = 0

# Variable height  settings
@export var rise_sustain_time: float = 0.38 # How long holding jump keeps velocity capped (gives taller jump)


# Float 
@export var enable_float: bool = true
@export var float_hold_time: float = 1.2
@export var unlimited_float: bool = true #float activation
@export var float_gravity_multiplier: float = 0.08 # Gravity multiplier while floating (smaller = slower fall)
@export var float_activation_delay: float = 0.4 # Time after starting to fall before float engages (prevents instant float at apex)

# General fall tuning
@export var fall_gravity_multiplier: float = 1.5 # Gravity when not floating (faster fall feel)

@export_category("Nodes")
@export var animation: AnimationPlayer
@export var player: Player

var jump_sfx = preload("res://audios/jump.mp3")
var rise_timer: float = 0.0
var float_timer: float = 0.0
var fall_time: float = 0.0
var is_jumping: bool = false
var is_floating: bool = false
var _current_force: float = 0.0

@export var jump_boost_resource: UpgradeResource = preload("res://resources/shop/upgrades/jumpboost.tres")


func _ready() -> void:
	var jump_boost_upgrade = player.player_stats_resource.find_upgrade("Jump Boost")

	if not jump_boost_upgrade:
		print("No jump boost found")
		final_jump_boost = initial_jump_force
		return
	final_jump_boost = initial_jump_force + jump_boost_upgrade.level * jump_boost_resource.stat_increase_per_level
	

func enter():
	# If a hurt-triggered lockout is active, immediately abort to running/falling state
	if player.block_jump_after_hurt:
		# Decide appropriate fallback state
		if player.is_on_floor():
			transitioned.emit(self, "running")
		else:
			transitioned.emit(self, "falling")
		return

	animation.play("jump")
	
	# Initialize jump
	rise_timer = 0.0
	float_timer = 0.0
	fall_time = 0.0
	_current_force = final_jump_boost
	is_jumping = true
	is_floating = false
	player.velocity.y = final_jump_boost
	AudioManager.play_sfx(jump_sfx)

func physics_update(delta: float):
	var gravity_y := player.get_gravity().y # positive downward

	if player.velocity.y < 0: # Rising phase
		fall_time = 0.0
		
		# While holding jump during rise, cap velocity to allow a higher jump (variable height)
		if Input.is_action_pressed("jump") and is_jumping and rise_timer < rise_sustain_time:
			rise_timer += delta
			
		else:
			player.velocity.y += gravity_y * delta
		is_floating = false
	elif player.velocity.y >= 0: # Falling or apex transition
		fall_time += delta
		var g_mult := fall_gravity_multiplier
	
		var float_time_ok := unlimited_float or float_timer < float_hold_time
		if enable_float and Input.is_action_pressed("jump") and float_time_ok and fall_time > float_activation_delay:
			is_floating = true
			float_timer += delta
			g_mult = float_gravity_multiplier
		else:
			is_floating = false
		player.velocity.y += gravity_y * g_mult * delta
	
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
	is_floating = false
	_current_force = 0.0
