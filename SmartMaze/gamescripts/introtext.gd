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
		1: update_textbox("[center]Visszanézel, és gyorsan meggyőződsz arról, hogy nem bírnál visszaindulni, mert mintha mögötted az út észrevétlenül eltűnne, úgy mintha nem is jártál volna ott. \"Nincs más hátra, mint előre\" - jegyzed meg szarkasztikusan, majd a következő lépésnél beszakad alattad a föld. Átesel egy kisebb alagútrendszeren, majd egy tisztáson kötsz ki, ahol egy látszólag ősi kőépület áll. Benézel, és látod hogy nem igazán szabályos az épület belső elrendezése. Egyszercsak egy hangot hallasz onnan bentről.[/center]")
		2: update_textbox("[center]\"Üdvözlégy utazó! Én, a labirintus beszélek tehozzád. Ez az Örök Tévelygés Erdeje. Innen nem tudsz kijutni, de én kivezethetlek innen. Viszont vannak szabályok! Időben át kell érned az útvesztőimen, vagy az út beszakad alattad és meghalsz, illetve ha túl sokat botorkálsz az utakon, akkor sem fog tudni téged megtartani a föld! De mielőtt elkezded itt utadat, jól nézzd meg merre kell menned, mert nem tart itt örökké a világosság! Emlékezeted menti meg életed! Sok sikert a kiúthoz!\"[/center]")
		3: get_tree().change_scene_to_file("res://game.tscn")

func update_textbox(update_text):
		visible_ratio = 0.0
		text = update_text
		current_text += 1
