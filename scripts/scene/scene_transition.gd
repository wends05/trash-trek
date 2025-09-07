extends CanvasLayer


@onready var trans_player: AnimationPlayer = $TransitionPlayer
var last_position
@onready var player_anim = $PlayerAnim

func _ready() -> void:
	player_anim.hide()
	$Start/StaticBody2D/CollisionShape2D.disabled = true
	
func change_scene(target: String, type: Utils.SceneType) -> void:
	match type:
		Utils.SceneType.Gameplay:
			player_anim.show()
			Utils.anim_player(trans_player, "fade_in")
			await trans_player.animation_finished
			SceneHandler.last_background_scroll_offset = $Parallax/Background.scroll_offset
			SceneHandler.last_midground_scroll_offset = $Parallax/Midground.scroll_offset
			SceneHandler.last_foreground_scroll_offset = $Parallax/Foreground.scroll_offset
			get_tree().change_scene_to_file(target)
			Utils.anim_player(trans_player, "fade_out")
		Utils.SceneType.Menu, Utils.SceneType.GameOver:
			pass
			
