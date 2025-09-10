extends Resource

class_name UpgradeResource


var player_stats_resource: PlayerStatsResource = preload("res://resources/player_stats.tres")

@export var name: String
@export var description: String
@export var icon: Texture
@export var base_price: int
@export var price_per_level_multiplier: float
@export var stat_increase_per_level: float
@export var max_level: int
