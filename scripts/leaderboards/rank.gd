extends Control

class_name LeaderboardRank

var player_name : String = ""
var player_score : int
@onready var rank_texture: TextureRect = $%RankTexture
@onready var name_label: Label = $%Name
@onready var score_label: Label = $%Score

func _ready() -> void:
	name_label.text = player_name
	score_label.text = "%.f" % player_score
