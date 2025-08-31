extends State

class_name Hurt

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var player: Player = get_parent().get_parent()

func enter():
    animated_sprite.play("hurt")
    player.velocity = Vector2.ZERO

func physics_update(_delta: float):
    # Wait for the hurt animation to finish, then return to running if on floor
    if not animated_sprite.is_playing() and player.is_on_floor():
        transitioned.emit(self, "running")