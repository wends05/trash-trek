extends CharacterBody2D
class_name Player

# All jump parameters moved to Jump state for simpler management

@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var animation_tile_map: Sprite2D = $AnimationTileMap
@onready var state_machine: Node = $StateMachine

var is_hurt: bool = false
var block_jump_after_hurt: bool = false # Prevent accidental jump buffered during hurt
var trashCollection_sfx = preload("res://audios/pop.mp3")
var player_stats_resource: PlayerStatsResource = PlayerStatsResource.get_instance()

func _ready() -> void:
	var current_skin = player_stats_resource.get_equipped_skin()
	var skin_resource = SkinResource.find_instance(current_skin)

	ready_tile_map(skin_resource)

	if not state_machine:
		printerr("State machine not found")
		return

	state_machine.request_transition("running")

func ready_tile_map(skin_resource: SkinResource):
	animation_tile_map.texture = skin_resource.texture_tilemap

	

## Collect Trash
func _on_trash_collection_area_area_entered(area: Area2D) -> void:
	if area.get_parent() is Trash:
		var trash: Trash = area.get_parent()
		Game.trash_collected.emit(trash.type)
		trash.remove()
		AudioManager.play_sfx(trashCollection_sfx)


## Throw Trash Logic
func _on_trash_bin_collection_area_area_entered(area: Area2D) -> void:
	if area.get_parent() is TrashBin:
		var trash_bin: TrashBin = area.get_parent()
		trash_bin.throw_trash()


## Hurt Game Logic
func _on_monster_collision_area_entered(_area: Area2D) -> void:
	Game.player_hurt(10)
	if is_hurt:
		return
	is_hurt = true
	# Ask state machine to transition to hurt state (avoid duplicate if already hurt)
	var cs = state_machine.get("current_state")
	if cs and cs.name.to_lower() != "hurt":
		state_machine.request_transition("hurt")
