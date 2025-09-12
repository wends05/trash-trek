extends CharacterBody2D
class_name Player

# All jump parameters moved to Jump state for simpler management

@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var state_machine: Node = $StateMachine

var is_hurt: bool = false
var block_jump_after_hurt: bool = false # Prevent accidental jump buffered during hurt

var player_stats_resource: PlayerStatsResource = PlayerStatsResource.get_instance()

func _ready() -> void:
	if not state_machine:
		printerr("State machine not found")
		return

	state_machine.request_transition("running")

## Collect Trash
func _on_trash_collection_area_area_entered(area: Area2D) -> void:
	if area.get_parent() is Trash:
		var trash: Trash = area.get_parent()
		Game.trash_collected.emit(trash.type)
		trash.remove()


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
