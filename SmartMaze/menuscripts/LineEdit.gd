extends LineEdit


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# megadhatjuk a kezdő pályaméretet, alapértelmezésként ez 10
func _on_text_changed(new_text):
	Global.mapsize = int(new_text)
