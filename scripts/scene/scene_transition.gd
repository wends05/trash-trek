extends CanvasLayer

signal credits_end

@onready var trans_player: AnimationPlayer = $TransitionPlayer
var last_position
@onready var player_anim = $PlayerAnim


func _ready() -> void:
	player_anim.hide()
	$Start/StaticBody2D/CollisionShape2D.disabled = true
	
func change_scene(scene: PackedScene, type: Utils.SceneType, container: Node = null) -> void:
	match type:
		Utils.SceneType.Gameplay:
			player_anim.show()
			Utils.anim_player(trans_player, "fade_in")
			await trans_player.animation_finished
			SceneHandler.last_background_scroll_offset = $Parallax/Background.scroll_offset
			SceneHandler.last_midground_scroll_offset = $Parallax/Midground.scroll_offset
			SceneHandler.last_foreground_scroll_offset = $Parallax/Foreground.scroll_offset
			switch_to_scene(scene)
			Utils.anim_player(trans_player, "fade_out")
		Utils.SceneType.Menu, Utils.SceneType.GameOver, Utils.SceneType.Credits:
			switch_to_scene(scene, container)

func switch_to_scene(scene: PackedScene, container: Node = null):
	var new_scene = scene.instantiate()
	
	if container:
		container.add_child(new_scene)
	else:
		var tree = get_tree()
		var current_scene = tree.current_scene
		tree.root.add_child(new_scene)
		tree.current_scene = new_scene
		if current_scene:
			current_scene.queue_free()
