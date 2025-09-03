extends CanvasLayer


@onready var garbage_trans: AnimatedSprite2D = $GarbageTrans

func change_scene(target: String) -> void:
	garbage_trans.play("fill")
	await garbage_trans.animation_finished
	get_tree().change_scene_to_file(target)
	garbage_trans.play_backwards("fill")
