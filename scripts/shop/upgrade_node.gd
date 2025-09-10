extends Control

class_name UpgradeDisplay

var upgrade_resource: UpgradeResource

@onready var upgrade_icon: TextureRect = $UpgradeIcon
@onready var name_label: Label = $Name
@onready var description_label: Label = $Description
@onready var stats_label: Label = $Stats
@onready var upgrade_button: TextureButton = $UpgradeButton
@onready var upgrade_button_label: Label = $UpgradeButtonLabel


signal coin_upgrade_error(message: String)


func _ready() -> void:
	if not upgrade_resource.player_stats_resource:
		printerr("No Player Stats Resource found")
		return
		
	if not upgrade_resource:
		printerr("No resource added")
		return

	PlayerApi.update_user_success.connect(_on_update_user_success)
	display_upgrade()

func display_upgrade():
	upgrade_icon.texture = upgrade_resource.icon
	name_label.text = upgrade_resource.name
	description_label.text = upgrade_resource.description
	
	display_upgrade_button()
	display_stats()

func get_player_upgrade():
	return upgrade_resource.player_stats_resource.get_upgrades().get(upgrade_resource.name)

func display_upgrade_button():
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

func display_stats():
	var player_upgrade = get_player_upgrade()

	if not player_upgrade:
		# assume level 1 upgrade
		stats_label.text = "1/%s" % upgrade_resource.max_level
		return
	
	stats_label.text = "%s/%s" % [player_upgrade.level, upgrade_resource.max_level]


func _on_upgrade_button_pressed() -> void:
	var err := upgrade_resource.player_stats_resource.upgrade_stat(upgrade_resource)

	if err:
		coin_upgrade_error.emit("%s: %s" % [upgrade_resource.name, err])
	else:
		display_upgrade()
		
func _on_update_user_success(data: Dictionary):
	print_debug("SUCESS EDIT PLAYER")
