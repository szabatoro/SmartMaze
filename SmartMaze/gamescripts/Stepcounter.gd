extends Label

# maradék lépések kiírása
func _process(_delta):
	self.text = "LE: " + str(get_parent().get_parent().steps_down) + "\n" + "FEL: " + str(get_parent().get_parent().steps_up) + "\n" + "JOBBRA: " + str(get_parent().get_parent().steps_right) + "\n" + "BALRA: " + str(get_parent().get_parent().steps_left)
