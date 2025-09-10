extends Control

class_name ShopInterface

enum Category {
	Upgrades,
	Skins
}

const CategoryScreens = [
	preload("res://assets/shop/shopupgrade.png"),
	preload("res://assets/shop/shopavatar.png")
]

@export var shop_api: ShopApi
@onready var screen: TextureRect = $ShopTexture
@onready var error_label: Label = $ErrorLabel
@export var item_container: ItemsContainer
@onready var coins_label: Label = $CoinsLabel
@onready var coin_error_label: Label = $%CoinErrorLabel
@onready var coin_error_container: Control = $%ErrorContainer


var player_stats_resource: PlayerStatsResource = preload("res://resources/player_stats.tres")
var current_screen: Category
var shop_items: Array


func _ready() -> void:
	current_screen = Category.Upgrades
	screen.texture = CategoryScreens[current_screen]

	player_stats_resource.coins_updated.connect(display_coins)

	# connect the api to the functions
	# shop_api.get_shop_items_success.connect(_on_get_shop_items)
	# shop_api.get_shop_items_failed.connect(_on_get_shop_items_failed)

	# # get local resources
	# var upgrades_dir = Utils.get_files_from_local_dir("res://resources/shop/upgrades")
	# var skins_dir = Utils.get_files_from_local_dir("res://resources/shop/skins")
	display_coins(player_stats_resource.coins)
	display_shop_items()
	

func _on_get_shop_items(result: Variant) -> void:
	shop_items = result

func display_coins(coins: int):
	coins_label.text = str(player_stats_resource.coins)
	

func display_shop_items():
	item_container.display_upgrades()
	item_container.display_skins()
	item_container.update_item_visibility()

func _on_get_shop_items_failed(err: Dictionary) -> void:
	_set_error_label(ApiService.parse_error_message(err))

func _on_return_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")

func _on_upgrade_button_pressed() -> void:
	current_screen = Category.Upgrades
	screen.texture = CategoryScreens[current_screen]
	item_container.update_item_visibility()

func _on_skin_button_pressed() -> void:
	current_screen = Category.Skins
	screen.texture = CategoryScreens[current_screen]
	item_container.update_item_visibility()

func _set_error_label(text: String):
	error_label.visible = true
	error_label.text = text

func display_coin_error(message: String):
	coin_error_container.visible = true if message else false
	coin_error_label.text = message
