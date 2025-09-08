extends CharacterBody2D
class_name Player

# All jump parameters moved to Jump state for simpler management

@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var state_machine: Node = get_node_or_null("StateMachine")

var is_hurt: bool = false
var block_jump_after_hurt: bool = false # Prevent accidental jump buffered during hurt

func _ready() -> void:
	add_to_group("Player")

func _physics_process(_delta: float) -> void:
	# Movement & jump handled by state machine states
	pass

## Legacy inline movement / jump / animation removed. Handled by Running / Jump / Falling / Hurt states.

func increment_trash(t: Utils.TrashType):
	Game.trash_collected.emit(t)

func _on_trash_collection_area_area_entered(area: Area2D) -> void:
	if area.get_parent() is Trash:
		var trash: Trash = area.get_parent()
		increment_trash(trash.type)
		trash.remove()
		
func _on_trash_bin_collection_area_area_entered(area: Area2D) -> void:
	if area.get_parent() is TrashBin:
		var trash_bin: TrashBin = area.get_parent()
		trash_bin.throw_trash()

func _on_monster_collision_area_entered(_area: Area2D) -> void:
	Game.decrease_energy(10)
	if is_hurt:
		return
	is_hurt = true
	# Ask state machine to transition to hurt state (avoid duplicate if already hurt)
	if state_machine and state_machine.has_method("request_transition"):
		# Only request if current state isn't already hurt
		var cs = state_machine.get("current_state")
		if cs and cs.name.to_lower() != "hurt":
			state_machine.request_transition("hurt")
