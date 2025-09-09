extends Node

class_name State
signal transitioned

func enter():
	pass
	
func exit():
	emit_signal("transitioned")
	
func update(_delta: float):
	pass
	
func physics_update(_delta: float):
	pass

func handle_input(_input: InputEvent):
	pass
