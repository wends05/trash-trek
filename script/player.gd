extends CharacterBody2D

class_name Player

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _physics_process(delta: float) -> void:      
	player_gravity(delta)
	player_jump()
	move_and_slide()
	
func player_jump() -> void:
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

func player_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
