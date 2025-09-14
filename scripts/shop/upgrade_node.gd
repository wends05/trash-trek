extends ShopItem

class_name UpgradeDisplay

var upgrade_resource: UpgradeResource

@onready var upgrade_icon: TextureRect = $UpgradeIcon
@onready var description_label: Label = $Description
@onready var stats_label: Label = $Stats
@onready var upgrade_button_label: Label = $UpgradeButtonLabel


func _ready_item():
	if not upgrade_resource.player_stats_resource:
		printerr("No Player Stats Resource found")
		return
		
	if not upgrade_resource:
		printerr("No resource added")
		return
	
	PlayerApi.update_user_success.connect(_on_update_user_success)


func _display_item():
	upgrade_icon.texture = upgrade_resource.icon
	name_label.text = upgrade_resource.name
	description_label.text = upgrade_resource.description
	
	super._display_item()


func get_player_upgrade():
	return upgrade_resource.player_stats_resource.get_upgrades().get(upgrade_resource.name)

#region Update States
func _display_buy_button():
	var player_upgrade = get_player_upgrade()

	if not player_upgrade:
		upgrade_button_label.text = "%d" % upgrade_resource.base_price
		upgrade_button.disabled = false
		return
	
	if player_upgrade.level >= upgrade_resource.max_level:
		upgrade_button.disabled = true
		upgrade_button_label.text = "MAX"
		return
	
	upgrade_button.disabled = false
	var final = upgrade_resource.base_price * upgrade_resource.price_per_level_multiplier * player_upgrade.level
	upgrade_button_label.text = "%d" % final

func _display_stats():
	var player_upgrade = get_player_upgrade()

	if not player_upgrade:
		# assume level 1 upgrade
		stats_label.text = "1/%s" % upgrade_resource.max_level
		return
	
	stats_label.text = "%s/%s" % [player_upgrade.level, upgrade_resource.max_level]
#endregion

func _on_upgrade_button_pressed() -> void:
	var err := upgrade_resource.player_stats_resource.upgrade_stat(upgrade_resource)

	super._check_error(err)
