extends Node2D

class_name TrashRemover

func _on_area_entered(area: Area2D) -> void:
	if area.get_parent() is Trash:
		var trash : Trash = area.get_parent()
		trash.remove()
	if area.get_parent() is TrashBin:
		var trash_bin : TrashBin = area.get_parent()
		trash_bin.remove()
