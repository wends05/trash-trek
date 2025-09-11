extends Control


@onready var display = $Display
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayerApi.get_top_five_success.connect(_on_get_top_five_success)
	PlayerApi.get_top_five()

func _on_get_top_five_success(result: Array) -> void:
	for player_idx in range(result.size()):
		var rank = preload("res://scenes/rank.tscn")
		var rank_node: LeaderboardRank = rank.instantiate()
		
		rank_node.player_name = result[player_idx].name
		rank_node.player_score = result[player_idx].high_score
		
		display.add_child(rank_node)
		
		
		var texture = load("res://assets/menu/leaderboards/rank%s.png" % (player_idx + 1))
		
		rank_node.rank_texture.texture = texture
