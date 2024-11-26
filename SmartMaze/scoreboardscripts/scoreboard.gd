extends Control

var elerteredmeny = Global.score
var jelenlegi_szint = Global.level

# Called when the node enters the scene tree for the first time.
func _ready():
	#$ScrollContainer.get_v_scrollbar().rect_scale.x = 0
	update_scoreboard()
	if !AudioPlayer.is_menu_music_playing:
		AudioPlayer.play_menu_music()
		if AudioPlayer.is_game_music_playing:
			AudioPlayer.stop_game_music()
	$HBoxContainer/Points.text = "0"
	if elerteredmeny != 0 && jelenlegi_szint == 6:
		$Score.text = $Score.text + str(elerteredmeny)
	else:
		$HBoxContainer.hide()
		# $Score.text = "Még nincs elért eredményed!"
		$Score.hide()
		

#var user_panel = preload("res://scoreboardscripts/scoreboard_user.tscn")
var client = HTTPClient.new()

# API megoldás - 30 másodperc késés update után
#const url_data = "https://opensheet.elk.sh/12WCKxIKc4WjKCwTm6sJJtYO1svfB74LmeayAlSnC7Hs/main"

#Böngészőn keresztül letöltött json.txt
const url_data = "https://docs.google.com/spreadsheets/d/12WCKxIKc4WjKCwTm6sJJtYO1svfB74LmeayAlSnC7Hs/gviz/tq"


const url_submit = "https://docs.google.com/forms/u/0/d/e/1FAIpQLSdbUFp0-lHz19y8o6xojXvg0gsfU3wCp6je93XzOIYPwWmDpg/formResponse"
const headers = ["Content-Type: application/x-www-form-urlencoded"]
#entry.1843914338: Stan
#entry.1204468850: 100
# opensheet API https://opensheet.elk.sh/12WCKxIKc4WjKCwTm6sJJtYO1svfB74LmeayAlSnC7Hs/main
# id 12WCKxIKc4WjKCwTm6sJJtYO1svfB74LmeayAlSnC7Hs
# table_name main




# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func http_submit(_result, _response_code, _headers, _body):
	#asd.queue_free()
	pass
	
func _on_save_button_pressed():
	
	var http = HTTPRequest.new()
	http.request_completed.connect(http_submit)
	#http.connect("request_completed",self,"http_submit",[http])
	add_child(http)
	
	AudioPlayer.play_fx(Global.menu_button_sound)
	if $HBoxContainer/Points.text != str(0):
		elerteredmeny = int($HBoxContainer/Points.text)
		
	var user_data = client.query_string_from_dict({
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
		savedataclear()
		setdefaultglobal()
		$Name_l.show()
	
	var seconds = 3
	await get_tree().create_timer(seconds).timeout
	update_scoreboard()
	


# A beérkező adatokat kiírjuk a konzolra
func http_done(_result: int, _response_code: int, _headers: Array, _body: PackedByteArray) -> void:
	if _result == OK and _response_code == 200:
		var result = _body.get_string_from_utf8()
		
		# API megoldásnál ez a két sor nem kell!!!
		result = result.substr(result.find("rows\":")+6)
		result = result.substr(0,result.find(",\"parsedNumHeaders\""))
		
		
		var parse_result = JSON.parse_string(result)
		#print(parse_result)
		Global.scoreboard_list = parse_result
		var _pos = 0
		for n in parse_result:
				_pos += 1
				var Timestamp = n["c"][0]["f"]
				var Name = n["c"][1]["v"]
				var Points = n["c"][2]["v"]
				add_player_to_grid(str(_pos), str(Timestamp), str(Name), str(Points))
		for pos in Global.scoreboard_list.size():
			
			#print( str(pos) + str(Global.scoreboard_list[pos]["Name"]) + str(Global.scoreboard_list[pos]["Points"]) )
			
			# API megoldáshoz a felső sor kell!!! Nem API megoldáshoz az alsó
			#add_player_to_grid(str(pos+1), str(parse_result[pos]["Timestamp"]), str(parse_result[pos]["Name"]), str(parse_result[pos]["Points"]))
			pass
			
	else:
		print("HTTP request failed with code:", _response_code)

func add_player_to_grid(pos,time, player_name, score):
	
	var pos_label = Label.new()
	pos_label.text = "# " + str(pos) + "      " + str(time)
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
	AudioPlayer.play_fx(Global.menu_button_sound)
	scoreboard_cheat_button_pressed = 0
	get_tree().change_scene_to_file("res://menu.tscn")

var scoreboard_cheat_button_pressed = 0
func _on_cheat_button_pressed():
	if scoreboard_cheat_button_pressed >= 10:
		$HBoxContainer/Points.show()
		$HBoxContainer.show()
	else:
		scoreboard_cheat_button_pressed += 1
		
		
func savedataclear():
	if FileAccess.file_exists(Global.save_path):
		DirAccess.remove_absolute(Global.save_path)
		#get_node("Options/OptionsContainer/SaveDelete").text = "Mentés törölve."
	else:
		#get_node("Options/OptionsContainer/SaveDelete").text = "Nincs előző mentett játék."
		return

func setdefaultglobal():
	Global.mapsize = 10
	Global.waittime = 30.0
	Global.score = 0
