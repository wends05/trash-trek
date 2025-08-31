extends Node2D

class_name TrashBin


var type: Utils.TrashType
var trash_bin_resource: TrashBinResource

@onready var player_collision_area: StaticBody2D = $PlayerCollisionArea
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var icon: TextureRect = $Icon

@onready var debug_label: Label = $"debug label"

var amount_required: int = 0
@onready var amount_required_label: Label = $AmountRequiredLabel

func _ready() -> void:
	load_trash_bin()
	Game.changed_trash_type.connect(change_player_collision)
	Game.trash_collected.connect(check_collection)
	amount_required = [3, 6, 9].pick_random()
	amount_required_label.text = "%s" % amount_required

	update_debug_label()

func load_trash_bin():
	trash_bin_resource = Utils.get_trash_bin(type)

	animated_sprite.sprite_frames = trash_bin_resource.sprite_frames
	type = trash_bin_resource.type
	icon.texture = trash_bin_resource.icon_image

	change_player_collision(Game.selected_trash_type)
	animated_sprite.play("idle")


func change_player_collision(trash_type: Utils.TrashType) -> void:
	if trash_type != type:
		player_collision_area.set_collision_layer_value(4, true)
	else:
		player_collision_area.set_collision_layer_value(4, false)
	check_collection(trash_type)

func check_collection(trash_type: Utils.TrashType) -> void:
	if trash_type != type:
		return
	if Game.get_trash_count(trash_type) >= amount_required:
		player_collision_area.set_collision_layer_value(4, false)
	else:
		player_collision_area.set_collision_layer_value(4, true)
	update_debug_label()

func update_debug_label() -> void:
	debug_label.text = \
		"Collision: %s\nTrash Count: %s\n" % [
			player_collision_area.get_collision_layer_value(4),
			Game.get_trash_count(type)
		]

func throw_trash() -> void:
	Game.decrease_trash_count(type, amount_required)
	Game.add_energy(amount_required)
	animated_sprite.play("open")
	await animated_sprite.animation_finished
	animated_sprite.play("idle")
