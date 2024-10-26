extends Node
@onready var screen_size_container = $OptionsContainer/ScreenSizeContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_full_screen_toggled(toggled_on):
	AudioPlayer.play_fx(Global.menu_button_sound)
	if (toggled_on):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN, 0)
		screen_size_container.hide()
	else:
		_on_screen_size_selector_item_selected(1)
		_on_borderless_toggled(0)
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED, 0)
		screen_size_container.show()





func _on_borderless_toggled(toggled_on):
	AudioPlayer.play_fx(Global.menu_button_sound)
	if (toggled_on):
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, 1, 0)
	else:
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, 0, 0)


func _on_v_sync_toggled(toggled_on):
	AudioPlayer.play_fx(Global.menu_button_sound)
	if (toggled_on):
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED,0)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED,0)


func _on_screen_size_selector_item_selected(index):
	match index: 
		0:
			DisplayServer.window_set_size(Vector2i(1920,1080),0)
			DisplayServer.window_set_position(Vector2i(0,30),0)
		1:
			DisplayServer.window_set_size(Vector2i(1600,900),0)
			DisplayServer.window_set_position(Vector2i(0,30),0)
		2:
			DisplayServer.window_set_size(Vector2i(1280,720),0)
			DisplayServer.window_set_position(Vector2i(0,30),0)


func _on_master_value_changed(value):
	volume(0, value)


func _on_music_value_changed(value):
	volume(1, value)


func _on_fx_value_changed(value):
	volume(2, value)

func volume(index, value):
	AudioServer.set_bus_volume_db(index,linear_to_db(value))
