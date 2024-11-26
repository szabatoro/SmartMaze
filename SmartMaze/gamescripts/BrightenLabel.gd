extends Label

var first_few_seconds = true # 

func _process(delta):
	# ha megy a BrightenCooldown timer, és ez nem a játék elején történt, kiírjuk a pályán elszenvedett pontlevonást
	if !$BrightenCooldown.is_stopped() and !first_few_seconds:
		self.text = "-" + str(get_parent().get_parent().score_penalty) + " pont!"

# mikor a BrightenCoolDown timer végetér, az eredeti szöveget visszahelyezzük, illetve 
# beállítjuk, hogy már biztos nem a játék elején vagyunk
func _on_brighten_cooldown_timeout():
	self.text = "F: pálya bevilágítása"
	first_few_seconds = false
