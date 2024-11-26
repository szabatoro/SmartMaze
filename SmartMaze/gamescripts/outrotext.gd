extends RichTextLabel

var current_text = 1

# kezdeti állapotban nincs megjelenített szöveg
func _ready():
	visible_ratio = 0.0

# az időzítő egy századmásodpercenként inkrementálja a megjelenített szöveg arányát
func _on_text_timer_timeout():
	if visible_ratio != 1.0:
		visible_ratio += 0.01

# a "következő" gombot nyomogatva megkapjuk a bevezető szöveg többi részét, majd bekerülünk a játéktérre
func _on_next_button_pressed():
	match current_text:
		1: update_textbox("[center]\"Szép volt,\" - szólt a labirintus - \"kijutottál, utazó. Mostmár szabad vagy. Melletted az ösvény, ami innen kivisz. \"[/center]")
		2: update_textbox("[center]Megköszönöd a labirintusnak a segítséget és elindulsz az ösvényen. Nem sokkal később ismerős úton találod magad, ahonnan a pontosan oda érkezel vissza, ahonnan az erdőbe beindultál.\nElsőként jutottál ki az őserdőből.[/center]")
		3: go_to_scoreboard()
	AudioPlayer.play_fx(Global.menu_button_sound)

# visszaállítjuk a megjelenített szöveg arányát nullára, és a paraméterben megadott szövegre állítjuk a labelt
func update_textbox(update_text):
		visible_ratio = 0.0
		text = update_text
		current_text += 1

# mivel a játékot befejeztük, töröljük a mentésünket, majd átlépünk a scoreboard-ra
func go_to_scoreboard():
	if FileAccess.file_exists(Global.save_path): # először ellenőrizzük, hogy van-e egyáltalán mentésfájl
		DirAccess.remove_absolute(Global.save_path) # ha van, azt töröljük
	get_tree().change_scene_to_file("res://scoreboardscripts/scoreboard.tscn")
