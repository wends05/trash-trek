extends ShopItem

class_name SkinDisplay

var skin_resource: SkinResource

@onready var skin_display: TextureRect = $%SkinDisplay
@onready var equip_button: BaseButton = $%EquipButton
@onready var equip_button_label: Label = $%EquipButtonLabel

func check_unavailable():
	if skin_resource.texture_tilemap.resource_path == "res://assets/Player/unavailable.png":
		upgrade_button.disabled = true
		upgrade_button_label.text = "Unavailable"
		equip_button.disabled = true
		equip_button_label.text = "Unavailable"
		skin_display.modulate = Color(0, 0, 0, 1)
		return

func _ready_item():
	if not skin_resource:
		printerr("No resource added")
		return
	
	if not skin_resource.texture_tilemap:
		printerr("No animation sprites found")
		return
	
	skin_display.texture = create_atlas_texture()
	
	skin_resource.player_stats_resource.equipped_skin_changed.connect(_display_item_stats)


func create_atlas_texture():
	check_unavailable()
	var atlas_texture = AtlasTexture.new()
	atlas_texture.region = Rect2(0, 0, 1536, 1536)
	atlas_texture.atlas = skin_resource.texture_tilemap
	return atlas_texture

func _display_item():
	check_unavailable()
	name_label.text = skin_resource.name
	super._display_item()

func get_player_skin():
	return skin_resource.player_stats_resource.find_skin(skin_resource.name)

func _display_buy_button():
	check_unavailable()
	var is_owned = get_player_skin()
	if skin_resource.name == "Default" or is_owned != -1:
		upgrade_button.disabled = true
		upgrade_button_label.text = "Owned"
	else:
		cost = skin_resource.base_price
		super._display_buy_button()

func _display_item_stats():
	check_unavailable()
	var equipped_skin = skin_resource.player_stats_resource.get_equipped_skin()
	var is_owned = get_player_skin()

	if is_owned == -1:
		if skin_resource.name != "Default":
			equip_button_label.text = "Not Owned"
			equip_button.disabled = true
		return

	if equipped_skin == skin_resource.name:
		equip_button_label.text = "Equipped"
		equip_button.disabled = true
	else:
		equip_button_label.text = "Equip"
		equip_button.disabled = false
	

func _on_upgrade_button_pressed() -> void:
	var err = skin_resource.player_stats_resource.buy_skin(skin_resource)
	_check_api_error(err)


func _on_equip_button_pressed() -> void:
	var err = skin_resource.player_stats_resource.equip_skin(skin_resource.name)
	_check_api_error(err)
