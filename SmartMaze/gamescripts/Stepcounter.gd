extends Label

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# maradék lépések kiírása
	self.text = "LE: " + str(get_parent().get_parent().steps_down) + "\n" + "FEL: " + str(get_parent().get_parent().steps_up) + "\n" + "JOBBRA: " + str(get_parent().get_parent().steps_right) + "\n" + "BALRA: " + str(get_parent().get_parent().steps_left)
