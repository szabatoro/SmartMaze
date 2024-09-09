extends CharacterBody2D

@export var tilemap: TileMap

var tilesizes # egy adott pályablokk mérete px-ben
var current_tile # a játékos adott pillanatbeli tartózkodási helye
var eligible_tiles # nem fal blokkok

func starting_position():
	# a pályablokkok négyzetek, tehát az egyik oldal leolvasása elég
	tilesizes = tilemap.get_tileset().tile_size.y 
	# a vektor a textúra atlaszban lévő koordináták közül a járható úté, az ezekkel rendelkező blokkokat szedi össze
	eligible_tiles = tilemap.get_used_cells_by_id(0,-1,Vector2i(1,1),-1)
	# a játékos mindig a legelső nem fal blokkból indul
	current_tile = eligible_tiles.front()
	# az előbbi blokk pozícióját adjuk meg a játékos pozíciójának
	var player_start_pos = tilemap.map_to_local(current_tile)
	# elhelyezzük a játékost
	self.global_position = Vector2i(player_start_pos.x,player_start_pos.y)

# Called when the node enters the scene tree for the first time.
func _ready():
	# Megvárja a parent node-ban lévő script lefutását
	await owner.ready
	# elhelyezi a játékost a kezdőpontban
	starting_position()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# leolvassa a karakter jelenlegi pozícióját
	var current_position = self.global_position
	# lefelé haladás
	if Input.is_action_just_pressed("down"):
		# koordináta vektor módosítása az adott iránynak megfelelően
		var next_tile = current_tile + Vector2i(0,1)
		# ha az adott irányban nem fal van, lépünk
		if eligible_tiles.has(next_tile):
			current_tile = next_tile
			# mivel a tilemap koordinátája lokális a player pedig globális, ezért át kell alakítanunk
			# globálissá a map_to_local függvénnyel
			self.global_position = tilemap.map_to_local(current_tile) 
			# átírjuk az előző jelenlegi pozíciót a mostanival
			current_position = self.global_position 
			# egy lépéssel kevesebb marad
			get_parent().steps -= 1
	# felfelé haladás, részleteket lásd feljebb
	if Input.is_action_just_pressed("up"):
		var next_tile = current_tile - Vector2i(0,1)
		if eligible_tiles.has(next_tile):
			current_tile = next_tile
			self.global_position = tilemap.map_to_local(current_tile)
			current_position = self.global_position
			# egy lépéssel kevesebb marad
			get_parent().steps -= 1
	# balra haladás, részleteket lásd feljebb
	if Input.is_action_just_pressed("left"):
		var next_tile = current_tile - Vector2i(1,0)
		if eligible_tiles.has(next_tile):
			current_tile = next_tile
			self.global_position = tilemap.map_to_local(current_tile)
			current_position = self.global_position
			# egy lépéssel kevesebb marad
			get_parent().steps -= 1
	# jobbra haladás, részleteket lásd feljebb
	if Input.is_action_just_pressed("right"): 
		var next_tile = current_tile + Vector2i(1,0)
		if eligible_tiles.has(next_tile):
			current_tile = next_tile
			self.global_position = tilemap.map_to_local(current_tile)
			current_position = self.global_position
			# egy lépéssel kevesebb marad
			get_parent().steps -= 1
