extends Node

func test_step_count():
	# Lekérjük a játékos (CharacterBody2D) node-ját
	var player = $Player  # Itt a $Player a játékos node útvonala

	var initial_steps = player.get_parent().steps
	var current_tile = player.current_tile

	# Szimuláljuk a játékos mozgását egy üres csempére
	var next_tile = current_tile + Vector2i(0, 1)
	if player.eligible_tiles.has(next_tile):
		player.current_tile = next_tile
		player.global_position = player.tilemap.map_to_local(next_tile)
		player.get_parent().steps -= 1

	# Assert hogy a lépésszám csökkent
	assert(player.get_parent().steps == initial_steps - 1)
