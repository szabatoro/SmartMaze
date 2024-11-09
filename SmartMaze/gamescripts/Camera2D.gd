extends Camera2D

@export var tilemap: TileMap

func change_zoomlevel(vs, ts, tms):
	# Kiszámítja a szükséges nagyítást (lásd később)
	var zoomlevel = float(vs / (ts * tms))
	# A nagyító funkció vektorral számol, így kell átadni a nagyítási értéket
	return Vector2(zoomlevel,zoomlevel)

# Called when the node enters the scene tree for the first time.
func _ready():
	# Megvárja a parent node-ban lévő script lefutását
	await owner.ready
	# Leolvassa az ablakméretet px-ben
	var viewport_size = float(get_viewport_rect().size.y)
	# Leolvassa a pályablokkok méretét px-ben
	var tile_size = float(tilemap.get_tileset().tile_size.y)
	# Leolvassa a pálya méretét pályablokkokban
	var tilemap_size = float(tilemap.get_used_cells(0).back().y + 1)
	# A pálya közepéhez rendeljük a kamerát
	self.global_position = tilemap.global_position + Vector2((tilemap_size*tile_size)/2, (tilemap_size*tile_size)/2)
	# Megadja a kamerának, hogy mennyire kell ránagyítson a pályára, hogy az betöltse az ablakot
	var zoom_vector = change_zoomlevel(viewport_size, tile_size, tilemap_size)
	# Elvégzi a nagyítást
	set_zoom(zoom_vector)
