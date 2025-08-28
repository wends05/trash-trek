extends Node2D

class_name Trash

@export var type: Utils.TrashType = Utils.TrashType.Recyclable
@export var terrain_manager: TerrainManager

var trash_item_resource: TrashResource

func _ready() -> void:
	# Get a random trash item for this type
	trash_item_resource = Utils.get_random_trash_item()
	var texture_path = trash_item_resource.get_trash_texture_path()
	
	print("Loading texture from: ", texture_path)
	
	# Load the texture (using the correct node path)
	var texture = load(texture_path) 
	if texture:
		$Area/Sprite2D.texture = texture
		print("Successfully loaded texture for: ", trash_item_resource.trash_name)
	else:
		print("ERROR: Could not load texture at path: ", texture_path)
	
	add_to_group("Trash")
	
	# Display the trash type and item name
	$Label.text = "%s: %s" % [Utils.get_enum_name(Utils.TrashType, type), trash_item_resource]

func _physics_process(delta: float) -> void:
	position.x -= terrain_manager.speed * delta

func remove():
	queue_free()

func _on_area_area_entered(area: Area2D) -> void:
	if area is GroundArea:
		area.bring_trash_above(self, 0)
