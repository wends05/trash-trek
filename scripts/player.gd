extends CharacterBody2D

class_name Player

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
var is_jumping: bool = false

func _ready() -> void:
	add_to_group("Player")
	if animated_sprite:
		animated_sprite.play("running")
		
func _physics_process(delta: float) -> void:      
	player_gravity(delta)
	player_jump()
	animations()
	move_and_slide()
	
func player_jump() -> void:
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		is_jumping = true
		play_jump_animation()

func play_jump_animation():
	if animated_sprite:
		animated_sprite.play("jump")

func player_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		if is_jumping:
			is_jumping = false

			if animated_sprite:
				animated_sprite.play("running")

func animations():
	if not animated_sprite:
		return
	

	if is_on_floor() and not is_jumping:
			animated_sprite.play("running")
	elif not is_on_floor() and velocity.y > 0:
			animated_sprite.play("falling")

func increment_trash(type: Utils.TrashType):
	Game.trash_collected.emit(type)

func _on_trash_collection_area_area_entered(area: Area2D) -> void:
	if area.get_parent() is Trash:
		var trash : Trash = area.get_parent()
		var trash_type = trash.type
		increment_trash(trash_type)
		trash.remove()
		
