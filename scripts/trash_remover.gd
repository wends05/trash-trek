extends Node2D

class_name TrashRemover

func _on_area_entered(area: Area2D) -> void:
	if area.get_parent() is Trash:
		var trash : Trash = area.get_parent()
		print_debug("Removing trash")
		trash.remove()
