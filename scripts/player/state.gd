extends Node

class_name State
signal transitioned(state: State, to_state: String)

func enter():
	pass
	
func exit():
	pass
	
func update(_delta: float):
	pass
	
func physics_update(_delta: float):
	pass

func handle_input(_input: InputEvent):
	pass
