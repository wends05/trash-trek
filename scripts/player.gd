extends CharacterBody2D

class_name Player

@export var jump_force = -400.0
@export var max_jump_time: float = 0.3
@export var max_charge_time: float = 0.2

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var jump_timer: float = 0.0
var charge_timer: float = 0.0
var is_jumping: bool = false
var is_charging: bool = false
var is_hurt: bool = false

func _ready() -> void:
	add_to_group("Player")
		
func _physics_process(delta: float) -> void:
	player_fall(delta)
	player_jump(delta)
	player_run()
	move_and_slide()

func player_jump(time) -> void:
	if Input.is_action_just_pressed("jump") and is_on_floor():
		is_jumping = true
		is_charging = true
		jump_timer = 0.0
		charge_timer = 0.0
		
	if Input.is_action_pressed("jump") and is_jumping and is_charging:
		charge_timer += time
		play_animation(Utils.PlayerMotion.Jump)
		if charge_timer > max_charge_time:
			if jump_timer < max_jump_time:
				velocity.y = jump_force
				jump_timer += time
			else:
				is_jumping = false
				is_charging = false
				play_animation(Utils.PlayerMotion.Fall)
			
	if Input.is_action_just_released("jump"):
		is_jumping = false
		is_charging = false
		play_animation(Utils.PlayerMotion.Fall)
	
func player_fall(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		if velocity.y > 0:
			play_animation(Utils.PlayerMotion.Fall)

func player_run():
	if is_on_floor() and (not is_charging and not is_hurt):
		play_animation(Utils.PlayerMotion.Run)
		
func play_animation(animation: Utils.PlayerMotion) -> void:
	match animation:
		Utils.PlayerMotion.Jump:
			animated_sprite.play('jump')
		Utils.PlayerMotion.Fall:
			animated_sprite.play('falling')
		Utils.PlayerMotion.Run:
			animated_sprite.play('running')
		Utils.PlayerMotion.Hurt:
			animated_sprite.play("hurt")
		

func increment_trash(type: Utils.TrashType):
	Game.trash_collected.emit(type)

func _on_trash_collection_area_area_entered(area: Area2D) -> void:
	if area.get_parent() is Trash:
		var trash: Trash = area.get_parent()
		var trash_type = trash.type
		increment_trash(trash_type)
		trash.remove()

func _on_trash_bin_collection_area_area_entered(area: Area2D) -> void:
	if area.get_parent() is TrashBin:
		Game.handle_throw_trash(area.get_parent())

func _on_monster_collision_area_entered(_area: Area2D) -> void:
	Game.decrease_energy(10)
	is_hurt = true
	play_animation(Utils.PlayerMotion.Hurt)
	await animated_sprite.animation_finished
	is_hurt = false
	play_animation(Utils.PlayerMotion.Run)
