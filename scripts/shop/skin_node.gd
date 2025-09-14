extends ShopItem

class_name SkinDisplay

var skin_resource: SkinResource

func _ready_item():
	if not skin_resource:
		printerr("No resource added")
		return

func _display_item():
	super._display_item()
