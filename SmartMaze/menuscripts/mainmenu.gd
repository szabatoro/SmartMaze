extends CanvasLayer
@onready var options = $Options
@onready var menu = $Menu

# Called when the node enters the scene tree for the first time.
func _ready():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN, 0)
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, 1)
	AudioPlayer.play_menu_music()

# Játék betöltése
func load_game():
	# Megnyitjuk a mentés fájlt
	var file = FileAccess.open(Global.save_path, FileAccess.READ)
	
	# Betöltjük az elmentett változókat
	Global.mapsize = file.get_var()
	Global.score = file.get_var()
	Global.waittime = file.get_var()
	
	# A műveletek után a fájlt bezárjuk
	file.close()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func show_and_hide(first, second):
	first.show()
	second.hide()

# Új játék kezdése
func _on_start_game_pressed():
	# Újrainicializáljuk a global.gd-t kezdőadatokkal, illetve a megadott pályamérettel, ha az van
	Global.mapsize = 10
	Global.waittime = 20.0
	Global.score = 0
	get_tree().change_scene_to_file("res://game.tscn")
	AudioPlayer.play_fx(Global.menu_button_sound)
	AudioPlayer.stop_menu_music()
	
# Belépés a beállításokba
func _on_settings_pressed():
	AudioPlayer.play_fx(Global.menu_button_sound)
	show_and_hide(options,menu)

# Kilépés a játékból
func _on_quit_game_pressed():
	AudioPlayer.play_fx(Global.menu_button_sound)
	get_tree().quit()

# Visszalépés a beállításokból
func _on_back_from_options_pressed():
	AudioPlayer.play_fx(Global.menu_button_sound)
	show_and_hide(menu,options)


func _on_button_pressed():
	#var temp = $myStreamPlayer2D.get_playback_position()
	AudioPlayer.play_fx(Global.menu_button_sound)
	AudioPlayer.toggle_menu_music()


func _on_scoreboard_pressed():
	AudioPlayer.play_fx(Global.menu_button_sound)
	get_tree().change_scene_to_file("res://scoreboardscripts/scoreboard.tscn")
# Előző játék folytatása
func _on_continue_game_pressed():
	if FileAccess.file_exists(Global.save_path):
		load_game()
		get_tree().change_scene_to_file("res://game.tscn")
		AudioPlayer.play_fx(Global.menu_button_sound)
		AudioPlayer.stop_menu_music()
	else:
		get_node("Menu/ContinueGame").text = "Nincs előző mentett játék."
		return

# Meglévő mentés törlése
func _on_save_delete_pressed():
	if FileAccess.file_exists(Global.save_path):
		DirAccess.remove_absolute(Global.save_path)
		get_node("Options/OptionsContainer/SaveDelete").text = "Mentés törölve."
	else:
		get_node("Options/OptionsContainer/SaveDelete").text = "Nincs előző mentett játék."
		return
