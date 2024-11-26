
extends Node


# https://youtu.be/lILnUD3xph8?si=fnkv-0KACFTNH3wr
# const button_sound = preload("res://assets/audio/button_sound.ogg")
# const fx_time_alert_sound = preload("")

var temp
var is_menu_music_playing = false
var is_game_music_playing = false

# A két AudioStreamPlayer a menühöz és a játékhoz
var menu_music_player: AudioStreamPlayer
var game_music_player: AudioStreamPlayer

# Játék indításakor hívódik meg
func _ready():
	# AudioStreamPlayer inicializálása
	menu_music_player = AudioStreamPlayer.new()
	add_child(menu_music_player)
	menu_music_player.stream = Global.menu_music
	menu_music_player.volume_db = Global.menu_music_sound_volume
	menu_music_player.bus = "Music"
	
	game_music_player = AudioStreamPlayer.new()
	add_child(game_music_player)
	game_music_player.stream = Global.game_music
	game_music_player.volume_db = Global.game_music_sound_volume
	game_music_player.bus = "Music"
	
	# Induláskor menüzene szól
	#play_menu_music()

# Menü zene lejátszása
func play_menu_music():
	menu_music_player.play()
	is_menu_music_playing = true

# Menü zene megállítása
func stop_menu_music():
	menu_music_player.stop()
	is_menu_music_playing = false

# Menü zene szüneteltetése és folytatása
func toggle_menu_music():
	if menu_music_player.playing:
		temp = menu_music_player.get_playback_position()
		menu_music_player.stop()
	else:
		menu_music_player.play()
		menu_music_player.seek(temp)

# Játék zene lejátszása
func play_game_music():
	game_music_player.play()
	is_game_music_playing = true

# Játék zene megállítása
func stop_game_music():
	game_music_player.stop()
	is_game_music_playing = false

# Játék zene szüneteltetése és folytatása
func toggle_game_music():
	if game_music_player.playing:
		temp = game_music_player.get_playback_position()
		game_music_player.stop()
	else:
		game_music_player.play()
		game_music_player.seek(temp)

# Effekt lejátszása
func play_fx(sound: AudioStream, volume: float = Global.fx_sound_volume):
	var fx_player = AudioStreamPlayer.new()
	add_child(fx_player)
	fx_player.stream = sound
	fx_player.volume_db = volume
	fx_player.bus = "FX"
	fx_player.play()
	
	# Hang lejátszás után törölni az objektumot
	#fx_player.connect("finished", fx_player, "_on_fx_finished")

func _on_fx_finished():
	queue_free()



func set_fx_volume(volume: float):
	# Az effektlejátszó hangerő szabályozása
	for fx in get_children():
		if fx is AudioStreamPlayer and fx.name == "FX_PLAYER":
			fx.volume_db = volume
