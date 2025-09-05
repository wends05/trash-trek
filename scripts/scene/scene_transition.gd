extends CanvasLayer


@onready var garbage_trans: AnimationPlayer = $GarbageAnimation
var last_position

func change_scene(target: String) -> void:
	garbage_trans.play("fade_in")
	await garbage_trans.animation_finished
	get_tree().change_scene_to_file(target)
	garbage_trans.play("fade_out")
