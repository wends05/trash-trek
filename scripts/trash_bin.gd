extends Node2D

class_name TrashBin


@export var type: Utils.TrashType
@onready var player_collision_area: StaticBody2D = $PlayerCollisionArea

func _ready() -> void:
	var texture_path = "res://assets/trashbins/%s.png" % Utils.get_enum_name(Utils.TrashType, type)
	$Asset.texture = load(texture_path)
	Game.changed_trash_type.connect(change_player_collision)


#func change_player_collision(trash_type: Utils.TrashType) -> void:
	print("CHANGING COLLISION")
	player_collision_area.set_collision_layer_value(4, type != trash_type)
