extends Node2D

# a pálya, exportálva, hogy befolyásolhassuk az exportban megadott pálya asset méretét
@export var tilemap: TileMap
var is_game_over = false
var steps_total # kezdetben a térkép méretéből számított összlépésszám
# a lépések, amiket használni is fogunk a játék során
var steps_up
var steps_down
var steps_left
var steps_right
var score_penalty = 0 # a pályára újra rápillantásért cerébe elszenvedett pontlevonás
var starting_visibility # a pálya teljes egészét bevilágító PointLight2D kezdeti mérete
var calced = false #szükséges, hogy a _process-ben behívott pontszámítás ne 
# menjen végbe egynél többször

# a pályaméret négyzete az összlépésszám
func get_steps():
	var msize = Global.mapsize
	return msize*msize

func _ready():
	steps_total = get_steps() # megkapjuk az összlépésszámot
	# majd elosszuk egyenletesen a 4 irányba
	steps_down = steps_total/4
	steps_up = steps_total/4
	steps_left = steps_total/4
	steps_right = steps_total/4
	AudioPlayer.play_game_music() # a játék elején elindítjuk a háttérzenét
	# a fényforrás méretét beállítjuk a pálya méretére
	starting_visibility = Global.mapsize 
	$Player/ViewField.texture_scale = starting_visibility 
	$Player.set_process(false) # kezdetben nem mozgathatjuk a játékost

func _process(_delta):
	# az F gomb megnyomásakor újra ránézhetünk a pályára pont- és időlevonásért cserébe
	if Input.is_action_just_pressed("see_again") and $HUD/BrightenLabel/BrightenCooldown.is_stopped() and $BlackoutTimer.is_stopped():
		$Player/ViewField.texture_scale = starting_visibility # visszaállítjuk a fényt a teljes pálya lefedésére
		visibility_shrinker() # meghívjuk a fénylefedés csökkentéséért felelős animációt
		$HUD/BrightenLabel/BrightenCooldown.start(6) # elindítja a timert ami megakadályozza, hogy spamelhessük ezt a funkciót
		score_penalty += 15 * Global.level # szinttől függően nagyobb pontlevonás jár a "csalásért"

	# ha elfogynak a lépések, feldobja a pause menüt
	if steps_left + steps_right + steps_up + steps_down == 0:
		is_game_over = true
		Engine.time_scale = 0 # leállítjuk a játék működését
		$PauseMenu.show() # megjelnítjük a szünetmenüt
		if !calced: # ez az if kapu szükséges, mivel az update függvényen belül másképp ez minden képkocka alatt lejátszaná a hangokat
			calced = true # mivel ez true, ez a kódrészlet többé nem indulhat el
			AudioPlayer.stop_game_music() # megállítjuk a háttérzenét
			AudioPlayer.play_fx(Global.game_lose,Global.game_lose_sound_volume) # lejátsszuk a game_over hangeffektet

	# ha a játékos eléri a célt, a pálya végetér, megjelenik a win screen
	if $Player.global_position == tilemap.map_to_local(tilemap.get_used_cells_by_id(0,-1,Vector2i(1,1),-1).back()):
		win_screen()

	# pause menu
	if Input.is_action_just_pressed("escape") and !is_game_over:
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

# megadjuk a következő pálya fő változóit, illetve az összpontszámot növeljük
func progress_the_game(current_score):
	Global.mapsize += 4 # a következő menetben a játék 4 egységgel lesz nagyobb
	Global.waittime += 10.0 # illetve 10 másodperccel több időnk lesz
	Global.score += current_score # hozzáadjuk a pályán szerzett pontot az összpontszámhoz
	Global.level += 1 # lépünk a következő szintre

# kiszámítjuk a jelenlegi pontot, az egész játék során szerzett pontot,
# megjelenítjük a pályavégi összesítést
func win_screen():
	is_game_over = true
	Engine.time_scale = 0
	var current_score = ceil($Timer.time_left) + steps_left + steps_right + steps_up + steps_down - score_penalty
	if !calced: # ez az if kapu szükséges, mivel az update függvényen belül másképp ez minden képkocka alatt növelné a pontokat
		progress_the_game(current_score)
		AudioPlayer.play_fx(Global.game_win)
		calced = true
	$MapEnd.show() # megjelnítjük a pályavégi képernyőt
	if Global.level == 6: # ha befejeztük az utolsó 5. szintet, a játéknak vége, mehetünk az outro scene-re
		$MapEnd/Menu.visible = false # az outro scene miatt nem mehetünk vissza a menübe még
		$MapEnd/TotalScoreLabel.text = "A játéknak vége. A játék alatt összeszedett pontszámod: "
	$MapEnd/Score.text = str(current_score) # pályán szerzett pontszám kiírása
	$MapEnd/TotalScore.text = str(Global.score) # egész játék során szerzett pontszám kiírása

# ha lejár az időzítő, bedob a pause menube
func _on_timer_timeout():
	is_game_over = true
	Engine.time_scale = 0
	$PauseMenu.show()
	AudioPlayer.stop_game_music()

# ha az "újraindításra" kattintunk, újrakezdi a játékot
func _on_restart_pressed():
	Engine.time_scale = 1
	get_tree().reload_current_scene()
	AudioPlayer.play_fx(Global.menu_button_sound)

# kilépés a játékból
func _on_exit_pressed():
	AudioPlayer.play_fx(Global.menu_button_sound)
	get_tree().quit()

# továbblépés a következő pályára
func _on_continue_pressed():
	Engine.time_scale = 1
	AudioPlayer.play_fx(Global.menu_button_sound)
	Global.save_game()
	# ha befejeztük a 6. pályát, mehetünk az outro scene-re, másképp újratölti a pályát az új paraméterekkel
	if Global.level < 6:
		get_tree().reload_current_scene()
	else:
		get_tree().change_scene_to_file("res://outro.tscn")

# szünet menüből visszalépés a főmenübe
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
	Global.save_game()
	get_tree().change_scene_to_file("res://menu.tscn")

# mikor az első pár másodperc lejár, a mapot lesötétíjük és a karakter irányíthatóvá válik
func _on_blackout_timer_timeout():
	$Timer.paused = false # elindítjuk a visszaszámlálást
	$HUD/BrightenLabel/BrightenCooldown.start(5) # nem "csalhatunk" az első pár másodpercben
	$HUD/BlackOutLabel.hide() # a pálya megjegyzésére felszólító label eltűnik
	visibility_shrinker()
	$Player.set_process(true) # a játékos mozoghat

# leszűkíti a player PointLight2D scale-jét a játékos köré
func visibility_shrinker():
	$Player/ViewField/AnimationPlayer.get_animation("shrink_visibility").track_set_key_value(0,0,starting_visibility)
	$Player/ViewField/AnimationPlayer.get_animation("shrink_visibility").track_set_key_transition(0,0,0.06)
	$Player/ViewField/AnimationPlayer.play("shrink_visibility")
