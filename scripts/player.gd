extends CharacterBody2D
class_name Player

@export var base_jump_force: float = -260.0            # Initial impulse (negative = up)
@export var peak_additional_force: float = -260.0      # Additional negative force reached after full sustain
@export var charge_time: float = 0.2                   # Wind-up time before sustained boost starts
@export var sustain_time: float = 0.3                  # Time over which we lerp toward peak (after charge)
@export var short_hop_gravity_multiplier: float = 2.0  # Extra gravity when released early
@export var fall_gravity_multiplier: float = 1.0       # Multiplier while descending

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var state_machine: Node = get_node_or_null("StateMachine")

var is_hurt: bool = false

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
		Game.handle_throw_trash(trash_bin)

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
