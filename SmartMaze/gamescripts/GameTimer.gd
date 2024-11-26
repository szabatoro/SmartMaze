extends Timer

# inicializáljuk a pálya teljesítését behatároló időzítőt
func _ready():
	wait_time = Global.waittime
	self.paused = true
