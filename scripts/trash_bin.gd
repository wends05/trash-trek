extends Node2D

class_name TrashBin


var type: Utils.TrashType
var trash_bin_resource: TrashBinResource
var energyREgen_sfx = preload("res://audios/rising-bubbly-pop-351023.mp3")
@onready var player_collision_area: StaticBody2D = $PlayerCollisionArea
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var icon: TextureRect = $Icon

@onready var debug_label: Label = $"debug label"

var animating = false
var collected = false

var amount_required: int = 0
@onready var amount_required_label: Label = $AmountRequiredLabel

func _ready() -> void:
	amount_required = [3, 6, 9].pick_random()
	amount_required_label.text = "%s" % amount_required
	Game.changed_trash_type.connect(change_player_collision)
	Game.trash_collected.connect(change_player_collision.unbind(1))
	load_trash_bin()

func load_trash_bin():
	trash_bin_resource = Utils.get_trash_bin(type)

	animated_sprite.sprite_frames = trash_bin_resource.sprite_frames
	type = trash_bin_resource.type
	icon.texture = trash_bin_resource.icon_image

	change_player_collision()
	animated_sprite.play("idle")


func change_player_collision() -> void:
	var has_enough: bool = Game.get_trash_count(Game.selected_trash_type) >= amount_required
	var should_block: bool = not (has_enough and Game.selected_trash_type == type)

	player_collision_area.set_collision_layer_value(4, should_block)
	update_debug_label(Game.selected_trash_type)


func update_debug_label(trash_type: Utils.TrashType) -> void:
	debug_label.text = \
		"Collision: %s\nTrash Count for bin type: %s\nSelected Trash Type: %s" % [
			"Collide" if player_collision_area.get_collision_layer_value(4) else "Pass",
			Game.get_trash_count(type),
			Utils.get_enum_name(Utils.TrashType, trash_type)
		]

func throw_trash() -> void:
	if \
		animating or \
		collected or \
		Game.get_trash_count(type) < amount_required:
		return
	
	collected = true
	
	Game.throw_trash(type, amount_required)
	
	animating = true
	
	animated_sprite.play("open")
	AudioManager.play_sfx(energyREgen_sfx)
	await animated_sprite.animation_finished
	
	animated_sprite.play("idle")
	animating = false
	
	change_player_collision()
