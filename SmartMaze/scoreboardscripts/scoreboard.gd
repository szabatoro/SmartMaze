extends Control

var elerteredmeny = Global.score

# Called when the node enters the scene tree for the first time.
func _ready():
	#$ScrollContainer.get_v_scrollbar().rect_scale.x = 0
	if Global.score != 0:
		$Score.text = $Score.text + str(elerteredmeny)
		
	else:
		$HBoxContainer.hide()
		$Score.text = "Még nincs elért eredményed!"
	update_scoreboard()
	pass

#var user_panel = preload("res://scoreboardscripts/scoreboard_user.tscn")
var client = HTTPClient.new()

const url_data = "https://opensheet.elk.sh/12WCKxIKc4WjKCwTm6sJJtYO1svfB74LmeayAlSnC7Hs/main"
const url_submit = "https://docs.google.com/forms/u/0/d/e/1FAIpQLSdbUFp0-lHz19y8o6xojXvg0gsfU3wCp6je93XzOIYPwWmDpg/formResponse"
const headers = ["Content-Type: application/x-www-form-urlencoded"]
#entry.1843914338: Stan
#entry.1204468850: 100
# opensheet API https://opensheet.elk.sh/12WCKxIKc4WjKCwTm6sJJtYO1svfB74LmeayAlSnC7Hs/main
# id 12WCKxIKc4WjKCwTm6sJJtYO1svfB74LmeayAlSnC7Hs
# table_name main




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func http_submit(_result, _response_code, _headers, _body, http):
	http.queue_free()
	pass
	
func _on_save_button_pressed():
	var http = HTTPRequest.new()
	http.request_completed.connect(http_submit)
	#http.connect("request_completed",self,"http_submit",[http])
	add_child(http)
	
	var user_data = await client.query_string_from_dict({
		"entry.1843914338": $HBoxContainer/Name.text,
		"entry.1204468850": elerteredmeny
	})
	var err = http.request(url_submit,headers,HTTPClient.METHOD_POST,user_data)
	if err:
		http.queue_free()
	else:
		# ha sikerült menteni az adatot
		$HBoxContainer.hide()
		$Name_l.text = $HBoxContainer/Name.text
		$Name_l.show()
		update_scoreboard()



# A beérkező adatokat kiírjuk a konzolra
func http_done(_result: int, _response_code: int, _headers: Array, _body: PackedByteArray) -> void:
	if _result == OK and _response_code == 200:
		var parse_result = await JSON.parse_string(_body.get_string_from_utf8())
		print(parse_result)
		Global.scoreboard_list = parse_result
		for pos in Global.scoreboard_list.size():
			print( str(pos) + str(Global.scoreboard_list[pos]["Name"]) + str(Global.scoreboard_list[pos]["Points"]) )
			add_player_to_grid(str(pos), str(parse_result[pos]["Name"]), str(parse_result[pos]["Points"]))
	else:
		print("HTTP request failed with code:", _response_code)

func add_player_to_grid(pos, player_name, score):
	
	var pos_label = Label.new()
	pos_label.text = str(pos)
	pos_label.show()
	$ScrollContainer/GridContainer/pos_vbox.add_child(pos_label)
	
	var name_label = Label.new()
	name_label.text = str(player_name)
	name_label.show()
	$ScrollContainer/GridContainer/name_vbox.add_child(name_label)
	
	var score_label = Label.new()
	score_label.text = str(score)
	score_label.show()
	$ScrollContainer/GridContainer/score_vbox.add_child(score_label)
	

func update_scoreboard():
	var http = HTTPRequest.new()
	http.request_completed.connect(http_done)
	add_child(http)
	for n in $ScrollContainer/GridContainer/pos_vbox.get_children():
		$ScrollContainer/GridContainer/pos_vbox.remove_child(n)
		n.queue_free()
	for n in $ScrollContainer/GridContainer/name_vbox.get_children():
		$ScrollContainer/GridContainer/name_vbox.remove_child(n)
		n.queue_free()
	for n in $ScrollContainer/GridContainer/score_vbox.get_children():
		$ScrollContainer/GridContainer/score_vbox.remove_child(n)
		n.queue_free()
		
	var err = http.request(url_data, headers, HTTPClient.METHOD_GET)
	if err != OK:
		http.queue_free()


func _on_back_to_menu_pressed():
	get_tree().change_scene_to_file("res://menu.tscn")
