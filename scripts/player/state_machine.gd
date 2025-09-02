extends Node

@export var initial_state: State
var current_state: State
var states: Dictionary = {}

func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.transitioned.connect(on_child_transition)

	if not initial_state:
		print_debug("No initial state")
		return
	current_state = initial_state
	current_state.enter()

func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

func on_child_transition(state: State, new_state_name: String):
	if state != current_state:
		return

	var new_state = states.get(new_state_name.to_lower())
	if not new_state:
		print_debug("State '%s' not found!" % new_state_name)
		return

	current_state.exit()
	current_state = new_state
	current_state.enter()

# External API to request a transition from owning nodes (e.g., Player) without directly emitting signals
func request_transition(new_state_name: String):
	if not current_state:
		return
	on_child_transition(current_state, new_state_name)
