extends Label

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# maradék lépések kiírása
	self.text = "Lépések: " + str(get_parent().get_parent().steps)
