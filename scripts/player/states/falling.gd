extends State

@onready var animation: AnimationPlayer = get_parent().get_parent().get_node("AnimationPlayer")
@onready var player: Player = get_parent().get_parent()

func enter():
	animation.play("falling")

func physics_update(delta: float):
	player.velocity.y += player.get_gravity().y * delta
	player.move_and_slide()

	if player.is_on_floor():
		transitioned.emit(self, "running")
