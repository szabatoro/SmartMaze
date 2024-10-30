# ez a szkript tartalmazza a globális változókat

extends Node

# menüben megadott pályaméret
var mapsize_setter

# pályaméret
var mapsize = 10

# időzítő
var waittime = 20.0

# pontszám
var score = 0

# Menü és játékmenet zenék
const menu_music = preload("res://assets/audio/menu.wav")
const menu_music_sound_volume = -25
const game_music = preload("res://assets/audio/game_music.wav")
const game_music_sound_volume = -25

const menu_button_sound = preload("res://assets/audio/button-4-sound-menu.wav")
const game_lose = preload("res://assets/audio/game-fail.wav")
const game_lose_sound_volume = -10
const game_win = preload("res://assets/audio/game_win.wav")
const grass_step = preload("res://assets/audio/grass_step.wav")

var scoreboard_list = []
var scoreboard_saved_first = false
