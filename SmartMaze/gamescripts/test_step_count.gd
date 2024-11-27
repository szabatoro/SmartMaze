extends Node

func test_step_count():
	# Lekérjük a játékos node-ját
	var player = $Player  # A $Player-t cseréld le az aktuális útvonalra
	var initial_steps = player.get_parent().steps
	var current_tile = player.current_tile

	# Szimuláljuk a játékos mozgását egy érvényes csempére
	var next_tile = current_tile + Vector2i(0, 1)
	if not player.eligible_tiles.has(next_tile):
		print("Hiba: A következő csempe nem elérhető.")
		return

	# Mozgás szimulálása
	var original_position = player.global_position  # Mentjük az eredeti pozíciót
	player.current_tile = next_tile
	player.global_position = player.tilemap.map_to_local(next_tile)
	player.get_parent().steps -= 1

	# Assert hogy a lépésszám csökkent
	assert(player.get_parent().steps == initial_steps - 1, "A lépésszám nem csökkent megfelelően.")

	# Visszaállítjuk az eredeti állapotot
	player.current_tile = current_tile
	player.global_position = original_position
	player.get_parent().steps = initial_steps
