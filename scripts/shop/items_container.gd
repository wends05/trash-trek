extends Control

class_name ItemsContainer

var ITEMS = {
	"upgrade": preload("res://scenes/shop/upgrade.tscn"),
	"skin": preload("res://scenes/shop/skin.tscn")
}

@onready var upgrades_grid: GridContainer = $UpgradesGrid
@onready var skins_container: ScrollContainer = $SkinsContainer
@onready var skins_hb: HBoxContainer = $SkinsContainer/HBoxContainer

@export var shop_interface: ShopInterface

func display_upgrades():
	var upgrades = Utils.get_files_from_local_dir("res://resources/shop/upgrades")
	for upgrade in upgrades:
		prepare_upgrade(upgrade)

func display_skins():
	var skins = Utils.get_files_from_local_dir("res://resources/shop/skins")
	skins.erase("default.tres")
	skins.insert(0, "default.tres")

	print_debug(skins)
	for skin in skins:
		prepare_skin(skin)

func prepare_upgrade(item: String):
	var upgrade: UpgradeResource = load("res://resources/shop/upgrades/%s" % item)
	if upgrade == null:
		return
	var upgrade_node: UpgradeDisplay = ITEMS["upgrade"].instantiate()
	
	upgrade_node.upgrade_resource = upgrade
	upgrade_node.coin_upgrade_error.connect(shop_interface.display_coin_error)

	upgrades_grid.add_child(upgrade_node)
	

func prepare_skin(item: String):
	var skin: SkinResource = load("res://resources/shop/skins/%s" % item)
	if skin == null:
		return
	var skin_node: SkinDisplay = ITEMS["skin"].instantiate()
	
	skin_node.skin_resource = skin
	skin_node.coin_upgrade_error.connect(shop_interface.display_coin_error)

	skins_hb.add_child(skin_node)

func update_item_visibility():
	match shop_interface.current_screen:
		shop_interface.Category.Upgrades:
			upgrades_grid.visible = true
			skins_container.visible = false
		shop_interface.Category.Skins:
			skins_container.visible = true
			upgrades_grid.visible = false
