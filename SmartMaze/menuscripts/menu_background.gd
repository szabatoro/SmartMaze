extends TileMap


# random választva az assetekből kitöltjük a háttér tilemapot
func fill_background():
	for x in range(100*2):
		for y in range(100):
			self.set_cell(0, Vector2i(x, y), 0, Vector2(randi() % 2,2))

func _ready():
	await owner.ready
	# legeneráljuk a háttér tileokat
	fill_background()

func _on_background_timer_timeout():
	fill_background()
