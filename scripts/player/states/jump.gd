extends State

class_name Jump

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var player: Player = get_parent().get_parent()

func enter():
    animated_sprite.play("jump")
    # Apply jump force
    player.velocity.y = player.jump_force

func physics_update(_delta: float):
    # Apply gravity
    player.velocity.y += player.get_gravity() * _delta

    # Allow for variable jump height
    if not Input.is_action_pressed("jump") and player.velocity.y < 0:
        player.velocity.y += player.get_gravity() * _delta * 2

    player.move_and_slide()

    # Transition to running when landing
    if player.is_on_floor():
        transitioned.emit(self, "running")
        return

    # Transition to falling if moving downward
    if player.velocity.y > 0:
        transitioned.emit(self, "falling")
        return

func exit():
  pass