extends Node


func test_wall_collision():
	# Lekérjük a játékos (CharacterBody2D) node-ját
	var player = $Player  # Itt a $Player a játékos node pontos útvonala

	var current_tile = player.current_tile
	var eligible_tiles = player.eligible_tiles
	var tilemap = player.tilemap

	# Szimuláljuk a karakter mozgását egy fal felé (jobbra próbál lépni)
	var next_tile = current_tile + Vector2i(1, 0)
	if not eligible_tiles.has(next_tile):
		# Ellenőrizzük, hogy a pozíció nem változik, ha fal van ott
		var initial_position = player.global_position
		player.global_position = tilemap.map_to_local(current_tile)
		assert(player.global_position == initial_position)
