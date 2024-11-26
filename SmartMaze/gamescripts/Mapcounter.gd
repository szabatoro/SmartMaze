extends Label

# kiírjuk a pálya teljesítésére szánt maradék időt
func _process(_delta):
	self.text = "Maradék idő: " + str(ceil(get_parent().get_parent().get_child(-3).time_left))
