extends Control

@onready var sfx_player = $SFXPlayer
@onready var music_player = $MusicPlayer

func play_sfx(stream: AudioStream, volume: float = 0.0, pitch: float = 1.0, duration: float = -1.0):
	sfx_player.stream = stream
	sfx_player.volume_db = volume
	sfx_player.pitch_scale = pitch    
	sfx_player.play()
	await sfx_player.finished
	#if duration > 0.0:
		#var timer = get_tree().create_timer(duration)
		#var finished = await sfx_player.finished or timer.timeout
		#
		#if finished == timer.timeout and sfx_player.playing:
			#sfx_player.stop()
	#else:

func play_music(stream: AudioStream, volume: float = 0.0, pitch: float = 1.0, loop: bool = true):
	if stream == null:
		return
		
	if stream is AudioStreamMP3:
		stream.loop = loop
		
	music_player.stream = stream
	music_player.volume_db = volume
	music_player.play()

func stop_music():
	if music_player.playing:
		music_player.stop()
