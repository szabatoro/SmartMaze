extends TileMap

# a tilemap mérete szükséges a háttér elhelyezéséhez
@export var tilemap: TileMap

# random választva az assetekből kitöltjük a háttér tilemapot
func fill_background(ts):
	for x in range(ts*2):
		for y in range(ts):
			self.set_cell(0, Vector2i(x, y), 0, Vector2(randi() % 2,2))

# Called when the node enters the scene tree for the first time.
func _ready():
	await owner.ready
	# kiszámoljuk mekkora a map
	var tilemap_size = tilemap.get_used_cells(0).back().y + 1
	# a map méretét beszorozva nyolccal, ha kivonjuk a map pozíciójából, pont
	# a map közepéhez igazítjuk a nála kétszer szélesebb háttér tilemapet
	self.global_position = tilemap.global_position - Vector2(tilemap_size * 8,0)
	# legeneráljuk a háttér tileokat
	fill_background(tilemap_size)
