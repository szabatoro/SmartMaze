extends RichTextLabel

var current_text = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	visible_ratio = 0.0

func _on_text_timer_timeout():
	if visible_ratio != 1.0:
		visible_ratio += 0.01

func _on_next_button_pressed():
	match current_text:
		1: update_textbox("[center]\"Szép volt,\" - szólt a labirintus - \"kijutottál, utazó. Mostmár szabad vagy. Melletted az ösvény, ami innen kivisz. \"[/center]")
		2: update_textbox("[center]Megköszönöd a labirintusnak a segítséget és elindulsz az ösvényen. Nem sokkal később ismerős úton találod magad, ahonnan a pontosan oda érkezel vissza, ahonnan az erdőbe beindultál.\nElsőként jutottál ki az őserdőből.[/center]")
		3: go_to_scoreboard()

func update_textbox(update_text):
		visible_ratio = 0.0
		text = update_text
		current_text += 1

func go_to_scoreboard():
	if FileAccess.file_exists(Global.save_path):
		DirAccess.remove_absolute(Global.save_path)
	get_tree().change_scene_to_file("res://scoreboardscripts/scoreboard.tscn")
