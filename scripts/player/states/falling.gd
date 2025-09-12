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
