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
const game_music = preload("res://assets/audio/game_music.wav")
const menu_button_sound = preload("res://assets/audio/button-4-sound-menu.wav")
const game_lose = preload("res://assets/audio/game-fail.wav")
const game_win = preload("res://assets/audio/game_win.wav")
const grass_step = preload("res://assets/audio/grass_step.wav")


# Scoreboard

var player_name = ""

var scoreboard_list = []

var first_place = null

var second_place = null

var third_place = null

func _ready():
	SilentWolf.configure({
		"api_key": "JfZ41Ox1WD6Bf1e0BYljUa2Dmr1ZEn347POMzMk4",
		"game_id": "SmartMaze",
		"log_level": 1
	})

#func _physics_process(delta):
#	leaderboard()
	
#func leaderboard():
#	for score in Global.score:
#		Global.player_list.append(Global.player_name)
#	SilentWolf.configure_scores({
#	"open_scene_on_close": "res://scenes/menu.tscn"
#	})
