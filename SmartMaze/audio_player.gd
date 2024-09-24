extends AudioStreamPlayer

# https://youtu.be/lILnUD3xph8?si=fnkv-0KACFTNH3wr
const menu_music = preload("res://assets/audio/menu.wav")
const game_music = preload("res://assets/audio/game_music.ogg")
# const button_sound = preload("res://assets/audio/button_sound.ogg")
# const fx_time_alert_sound = preload("")

func _play_music(music: AudioStream, volume = 0.0):
	if stream == music:
		return
		
	stream = music
	volume = volume
	play()
	
func play_game_music():
	_play_music(game_music)

func play_menu_music():
	_play_music(menu_music)

# https://youtu.be/lILnUD3xph8?si=fnkv-0KACFTNH3wr
func _play_fx(music: AudioStream, volume = 0.0):
	var fx_player = AudioStreamPlayer.new()
	fx_player.stream = stream
	fx_player.name = "FX_PLAYER"
	fx_player.volume_db = volume
	add_child(fx_player)
	fx_player.play()
	
	await fx_player.finished
	
	fx_player.queue_free()
