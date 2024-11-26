extends Label

# figyelmeztetjük a játékost, hogy jegyezze meg a pályát, a kezdeti BlackOutTimer-t kiírjuk
func _process(_delta):
	self.text = "JEGYEZD MEG\n A PÁLYÁT!\n " + str(ceil(get_parent().get_parent().get_child(-4).time_left))
