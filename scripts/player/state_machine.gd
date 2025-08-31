extends Node

@export var initial_state: State
var current_state: State
var states: Dictionary[String, State] = {}

func _ready():
	for child: State in get_children():
		states[child.name] = child
		child.transitioned.connect(on_child_transition)

	if not initial_state:
		print_debug("No initial state")
		return
	initial_state.enter()
	current_state = initial_state

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
		return
	new_state.enter()

	current_state = new_state
