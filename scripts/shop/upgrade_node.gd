extends ShopItem

class_name UpgradeDisplay

var upgrade_resource: UpgradeResource

@onready var upgrade_icon: TextureRect = $UpgradeIcon
@onready var description_label: Label = $Description
@onready var stats_label: Label = $Stats


func _ready_item():
	if not upgrade_resource:
		printerr("No resource added")
		return
	
	if not upgrade_resource.player_stats_resource:
		printerr("No Player Stats Resource found")
		return


func _display_item():
	upgrade_icon.texture = upgrade_resource.icon
	name_label.text = upgrade_resource.name
	description_label.text = upgrade_resource.description
	
	super._display_item()

func get_player_upgrade():
	return upgrade_resource.player_stats_resource.find_upgrade(upgrade_resource.name)

func _display_buy_button():
	var player_upgrade = get_player_upgrade()

	var multiplier = 1
	var upgrade_per_level = 1

	if player_upgrade:
		multiplier = player_upgrade.level
		upgrade_per_level = upgrade_resource.price_per_level_multiplier
	
		if player_upgrade.level >= upgrade_resource.max_level:
			upgrade_button.disabled = true
			upgrade_button_label.text = "MAX"
			return
	
	cost = upgrade_resource.base_price * upgrade_per_level * multiplier
	
	super._display_buy_button()

func _display_item_stats():
	var player_upgrade = get_player_upgrade()

	if not player_upgrade:
		# assume level 1 upgrade
		stats_label.text = "1/%d" % upgrade_resource.max_level
		return
	
	stats_label.text = "%d/%s" % [player_upgrade.level, upgrade_resource.max_level]

func _on_upgrade_button_pressed() -> void:
	var err := upgrade_resource.player_stats_resource.upgrade_stat(upgrade_resource)

	_check_api_error(err)
