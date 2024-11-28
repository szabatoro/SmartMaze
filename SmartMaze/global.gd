# ez a szkript tartalmazza a globális változókat

extends Node

# A mentésfájl elérési útja
var save_path = "./savefile.save"

# jelenlegi szint
var level = 1

# pályaméret
var mapsize = 10

# időzítő
var waittime = 30.0

# pontszám
var score = 0

# beállítások
var fullscreen = 1
# jobb, ha inkább menübe lépéskor visszavált border ablakra
# var borderless = 0
var vsync = 1

# Menü és játékmenet zenék
const menu_music = preload("res://assets/audio/SMMenu.mp3")
const menu_music_sound_volume = -25
const game_music = preload("res://assets/audio/SMGameplay.mp3")
const game_music_sound_volume = -25

const menu_button_sound = preload("res://assets/audio/button-4-sound-menu.wav")
const game_lose = preload("res://assets/audio/game-fail.wav")
const game_lose_sound_volume = -10
const game_win = preload("res://assets/audio/game_win.wav")
const game_win_sound_volume = 0

const fx_sound_volume = -10
const grass_step = preload("res://assets/audio/grass_step.wav")


# Scoreboard adatok
var scoreboard_list = []

# Játékváltozók mentése egy bináris fájlba
func save_game():
	# Megnyissuk a fájlt
	var file = FileAccess.open(Global.save_path, FileAccess.WRITE)

	# Lementjük a menteni kívánt változókat
	file.store_var(Global.mapsize)
	file.store_var(Global.score)
	file.store_var(Global.waittime)
	file.store_var(Global.level)
	
	# A műveletek után bezárjuk a fájlt
	file.close()
