extends Label

# kiírjuk, hogy hányadik pályán vagyunk
func _ready():
	self.text = "SZINT: " + str(Global.level) + "/5"
