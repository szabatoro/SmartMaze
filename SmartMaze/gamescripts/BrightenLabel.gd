extends Label

var first_few_seconds = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !$BrightenCooldown.is_stopped() and !first_few_seconds:
		self.text = "-" + str(get_parent().get_parent().score_penalty) + " pont!"


func _on_brighten_cooldown_timeout():
	self.text = "F: pálya bevilágítása"
	first_few_seconds = false
