extends Control

class_name UI

func _ready() -> void:
	Game.trash_collected.connect(update_trash_counts)
	
func update_trash_counts():
	$TempTrashCount.text =\
	"rec: %s
	bio: %s
	tox: %s
	" % [
		Game.collected_recyclable,
		Game.collected_biodegradable,
		Game.collected_toxic_waste
	]
	
