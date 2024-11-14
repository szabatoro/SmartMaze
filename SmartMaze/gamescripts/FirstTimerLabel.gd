extends Label

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	self.text = "Belátási idő: " + str(ceil(get_parent().get_parent().get_child(-4).time_left))
