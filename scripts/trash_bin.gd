extends Node2D

class_name TrashBin


var type: Utils.TrashType
@onready var player_collision_area: StaticBody2D = $PlayerCollisionArea
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
var trash_bin_resource: TrashBinResource

func _ready() -> void:
	Game.changed_trash_type.connect(change_player_collision)
	load_trash_bin()
	

func load_trash_bin():
	trash_bin_resource = Utils.get_random_trash_bin()

	animated_sprite.sprite_frames = trash_bin_resource.sprite_frames
	type = trash_bin_resource.type
	change_player_collision(Game.selected_trash_type)
	
	animated_sprite.play("idle")

func change_player_collision(trash_type: Utils.TrashType) -> void:


func change_player_collision(trash_type: Utils.TrashType) -> void:
	print("CHANGING COLLISION")
	player_collision_area.set_collision_layer_value(4, type != trash_type)

func throw_trash() -> void:
	animated_sprite.play("open")
	await animated_sprite.animation_finished
	animated_sprite.play("idle")
