extends GridContainer
const _SilentWolf = preload("res://addons/silent_wolf/SilentWolf.gd")

func _ready():
	update()
	
func update():
	var sw_result: Dictionary = await SilentWolf.Scores.get_scores(0).sw_get_scores_complete
	Global.scoreboard_list = sw_result.scores
	for pos in Global.scoreboard_list.size():
		add_player_to_grid(str(pos), str(Global.scoreboard_list[pos]["player_name"]), str(Global.scoreboard_list[pos]["score"]))
		print( str(pos) + str(Global.scoreboard_list[pos]["player_name"]) + str(Global.scoreboard_list[pos]["score"]) )




func add_player_to_grid(pos, player_name, score):
	
	var pos_label = Label.new()
	pos_label.text = str(pos)
	pos_label.show()
	$pos_vbox.add_child(pos_label)
	
	var name_label = Label.new()
	name_label.text = str(player_name)
	name_label.show()
	$name_vbox.add_child(name_label)
	
	var score_label = Label.new()
	score_label.text = str(score)
	score_label.show()
	$score_vbox.add_child(score_label)
