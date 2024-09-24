extends CanvasLayer
@onready var options = $Options
@onready var menu = $Menu

# Called when the node enters the scene tree for the first time.
func _ready():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN, 0)
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, 1)
	# AudioPlayer.play_menu_music()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func show_and_hide(first, second):
	first.show()
	second.hide()

func _on_start_game_pressed():
	get_tree().change_scene_to_file("res://game.tscn")



func _on_settings_pressed():
	show_and_hide(options,menu)


func _on_map_size_text_changed(new_text):
	Global.mapsize = int(new_text)


func _on_quit_game_pressed():
	get_tree().quit()


func _on_back_from_options_pressed():
	show_and_hide(menu,options)