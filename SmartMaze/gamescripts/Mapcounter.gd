extends Label

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	self.text = "Maradék idő: " + str(ceil(get_parent().get_parent().get_child(-3).time_left))
