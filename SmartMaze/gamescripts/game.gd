extends Node2D

# A pálya mérete, exportálva a könnyű tesztelhetőségért
# @export var mapsize = 20 !!EZT FELVÁLTOTTA A GLOBAL.GD!!
# A pálya, exportálva, hogy befolyásolhassuk az exportban megadott pálya asset méretét
@export var tilemap: TileMap

var start_steps
var steps
var calced = false #szükséges, hogy a _process-ben behívott pontszámítás ne 
# menjen végbe egynél többször

func get_steps():
	var msize = Global.mapsize
	return msize*msize/4

# Called when the node enters the scene tree for the first time.
func _ready():
	# lépések (placeholder kiszámító)
	start_steps = get_steps()
	steps = start_steps
	AudioPlayer.play_game_music()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	# ha elfogynak a lépések, újratölti a pályát
	if steps == 0:
		Engine.time_scale = 0
		$PauseMenu.show()
		if !calced:
			calced = true
			AudioPlayer.stop_game_music()
			AudioPlayer.play_fx(Global.game_lose,-10)
		#steps = start_steps
		#get_tree().reload_current_scene()		
	# Ha a játékos eléri a célt, a pálya végetér, új pálya indul (erősen félkész)
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
			
# kiszámítjuk a jelenlegi pontot, az egész játék során szerzett pontot,
# megjelenítjük a pályavégi összesítést
func win_screen():
	Engine.time_scale = 0
	var current_score = ceil($Timer.time_left) + steps
	if !calced:
		Global.score += current_score
		calced = true
		AudioPlayer.play_fx(Global.game_win)
	# újratöltjük a játékot, új pályát létrehozva ezzel
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

# kilépés
func _on_exit_pressed():
	get_tree().quit()

#továbblépés a következő pályára
func _on_continue_pressed():
	Engine.time_scale = 1
	# a következő menetben a játék 4 egységgel lesz nagyobb
	# illetve 10 másodperccel több időnk lesz
	Global.mapsize += 4
	Global.waittime += 10.0
	steps = start_steps
	get_tree().reload_current_scene()
