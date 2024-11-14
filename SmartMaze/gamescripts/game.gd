extends Node2D

# A pálya mérete, exportálva a könnyű tesztelhetőségért
# @export var mapsize = 20 !!EZT FELVÁLTOTTA A GLOBAL.GD!!
# A pálya, exportálva, hogy befolyásolhassuk az exportban megadott pálya asset méretét
@export var tilemap: TileMap
var start_steps
var steps
var starting_visibility
var calced = false #szükséges, hogy a _process-ben behívott pontszámítás ne 
# menjen végbe egynél többször

func get_steps():
	var msize = Global.mapsize
	return msize*msize/4.0

# Called when the node enters the scene tree for the first time.
func _ready():
	# lépések (placeholder kiszámító)
	start_steps = get_steps()
	steps = start_steps
	AudioPlayer.play_game_music()
	starting_visibility = Global.mapsize
	$Player.set_process(false) # nem mozgathatjuk a játékost
	$Player/ViewField.texture_scale = starting_visibility

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	# ha elfogynak a lépések, feldobja a pause menüt
	if steps == 0:
		Engine.time_scale = 0
		$PauseMenu.show()
		if !calced:
			calced = true
			AudioPlayer.stop_game_music()
			AudioPlayer.play_fx(Global.game_lose,Global.game_lose_sound_volume)
		#steps = start_steps
		#get_tree().reload_current_scene()		
	# Ha a játékos eléri a célt, a pálya végetér, megjelenik a win screen
	if $Player.global_position == tilemap.map_to_local(tilemap.get_used_cells_by_id(0,-1,Vector2i(1,1),-1).back()):
		
		win_screen()
	#pause menu
	if Input.is_action_just_pressed("escape"):
		# Engine.time_scale alapján eldönti, már pauseolva van-e
		# majd megjeleníti/elrejti a pause menut
		if Engine.time_scale == 1:
			Engine.time_scale = 0
			$PauseMenu.show()
			AudioPlayer.toggle_game_music()
		elif Engine.time_scale == 0:
			Engine.time_scale = 1
			$PauseMenu.hide()
			AudioPlayer.toggle_game_music()
			
func progress_the_game(current_score):
	# a következő menetben a játék 4 egységgel lesz nagyobb
	# illetve 10 másodperccel több időnk lesz
	Global.mapsize += 4
	Global.waittime += 10.0
	# hozzáadjuk a pályán szerzett pontot az összpontszámhoz
	Global.score += current_score

# kiszámítjuk a jelenlegi pontot, az egész játék során szerzett pontot,
# megjelenítjük a pályavégi összesítést
func win_screen():
	Engine.time_scale = 0
	var current_score = ceil($Timer.time_left) + steps
	if !calced:
		progress_the_game(current_score)
		AudioPlayer.play_fx(Global.game_win)
		calced = true
	$MapEnd.show()
	$MapEnd/Score.text = str(current_score)
	$MapEnd/TotalScore.text = str(Global.score)

# ha lejár az időzítő, bedob a pause menube
func _on_timer_timeout():
	Engine.time_scale = 0
	$PauseMenu.show()
	AudioPlayer.stop_game_music()

# ha az "újraindításra" kattintunk, újrakezdi a játékot
func _on_restart_pressed():
	Engine.time_scale = 1
	steps = start_steps
	get_tree().reload_current_scene()
	AudioPlayer.play_fx(Global.menu_button_sound)

# kilépés
func _on_exit_pressed():
	AudioPlayer.play_fx(Global.menu_button_sound)
	get_tree().change_scene_to_file("res://scoreboardscripts/scoreboard.tscn")

#továbblépés a következő pályára
func _on_continue_pressed():
	Engine.time_scale = 1
	#Global.mapsize += 4
	#Global.waittime += 10.0
	steps = start_steps
	AudioPlayer.play_fx(Global.menu_button_sound)
	save_game()
	get_tree().reload_current_scene()

# Szünet menüből visszalépés a főmenübe
func _on_back_to_menu_pressed():
	AudioPlayer.play_fx(Global.menu_button_sound)
	AudioPlayer.stop_game_music()
	if Engine.time_scale == 0:
		Engine.time_scale = 1
	get_tree().change_scene_to_file("res://menu.tscn")

# Win screen-ről visszatérés a főmenübe
func _on_menu_pressed():
	AudioPlayer.play_fx(Global.menu_button_sound)
	AudioPlayer.stop_game_music()
	if Engine.time_scale == 0:
		Engine.time_scale = 1
	save_game()
	get_tree().change_scene_to_file("res://menu.tscn")

	
# Játékváltozók mentése egy bináris fájlba
func save_game():
	# Megnyissuk a fájlt
	var file = FileAccess.open(Global.save_path, FileAccess.WRITE)

	# Lementjük a menteni kívánt változókat
	file.store_var(Global.mapsize)
	file.store_var(Global.score)
	file.store_var(Global.waittime)
	
	# A műveletek után bezárjuk a fájlt
	file.close()

# Mikor az első pár másodperc lejár, a mapot lesötétíjük és a karakter irányíthatóvá válik
func _on_first_timer_timeout():
	$Timer.paused = false # elindítjuk a visszaszámlálást
	$HUD/FirstTimerLabel.hide()
	$Player/ViewField/AnimationPlayer.get_animation("shrink_visibility").track_set_key_value(0,0,starting_visibility)
	$Player/ViewField/AnimationPlayer.get_animation("shrink_visibility").track_set_key_transition(0,0,0.06)
	$Player/ViewField/AnimationPlayer.play("shrink_visibility")
	$Player.set_process(true) # a játékos mozoghat
