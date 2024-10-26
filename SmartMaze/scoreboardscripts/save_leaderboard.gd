extends Control

@onready var elerteredmenyed = $SaveForm/Score
# const _SilentWolf = preload("res://addons/silent_wolf/SilentWolf.gd")
#const leaderboard = preload("res://scoreboardscripts/leaderboard.gd")

var calced = false

# Called when the node enters the scene tree for the first time.
func _ready():
	AudioPlayer.play_menu_music()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !calced:
		elerteredmenyed.text = elerteredmenyed.text +" "+ str(Global.score)
		calced = true
	


func _on_name_text_changed(new_text):
	Global.player_name = new_text

func _on_submit_for_scoreboard_pressed():
	$SaveForm.hide()
	var sw_result: Dictionary = await SilentWolf.Scores.save_score(Global.player_name, Global.score).sw_save_score_complete
	$Leaderboard.show()


func _on_back_to_menu_pressed():
	AudioPlayer.play_fx(Global.menu_button_sound)
	get_tree().change_scene_to_file("res://menu.tscn")
