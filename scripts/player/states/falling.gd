extends State

@onready var animated_sprite: AnimatedSprite2D = get_parent().get_parent().get_node("AnimatedSprite2D")
@onready var player: Player = get_parent().get_parent()

func enter():
  animated_sprite.play("falling")

func physics_update(_delta: float):
  # Apply gravity
  player.velocity.y += player.get_gravity().y * _delta
  player.move_and_slide()

  # Transition to running if landed
  if player.is_on_floor():
    transitioned.emit(self, "running")
    return

func exit():
  pass
