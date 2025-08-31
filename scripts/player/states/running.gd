extends State

class_name Running

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var player: Player = get_parent().get_parent()

func enter():
	animated_sprite.play("running")

func physics_update(_delta: float):
	# Transition to falling if not on floor
	if !player.is_on_floor():
		transitioned.emit(self, "falling")
		return

	# Transition to jump if jump is pressed
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		transitioned.emit(self, "jump")
		return

	# Auto-run forward at constant speed
	player.velocity.x = 300.0 # Set your desired speed

	player.move_and_slide()
