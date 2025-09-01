extends State

class_name Running

@onready var animated_sprite: AnimatedSprite2D = get_parent().get_parent().get_node("AnimatedSprite2D")
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

	

	player.move_and_slide()
